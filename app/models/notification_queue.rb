class NotificationQueue < ApplicationRecord
    def self.process(attrs)
        if attrs.has_key?(:claim_id)
            query = "claim_id = #{attrs[:claim_id]}"
        elsif attrs.has_key?(:prediction_id)
            query = "prediction_id = #{attrs[:prediction_id]}"
        elsif attrs.has_key?(:expert_id)
            query = "expert_id = #{attrs[:expert_id]}"
        end
 
        if attrs.has_key?(:user_id)
            query += " and user_id = #{attrs[:user_id]}" 
        end

        @bookmarks = Bookmark.where(query)
        
        @bookmarks.each do |bookmark|
            if bookmark.notify == true
                if bookmark.user.notification_frequency == 1
                    @newItem = self.add_to_notification_queue(attrs)
                    self.delay.compile_and_send_email([@newItem], nil, bookmark.user)
                else

                    self.delay.add_to_notification_queue(attrs)
                end
            end

            bookmark.update({ has_update: true })
        end
    end


    def self.add_to_notification_queue(attrs)
        return NotificationQueueItem.create(attrs)
    end


    def self.process_daily_digests
        @date = Time.now
        @range_from = @date.yesterday.beginning_of_day
        @range_to = @date.yesterday.end_of_day

        @users = NotificationQueueItem.distinct.pluck(:user_id)
        @users.each do |user|
            u = User.find_by_id(user)
            if !u.nil? and u.notification_frequency == 2
                @queueItems = NotificationQueueItem.where("created_at >= '#{@range_from}' and created_at <= '#{@range_to}'").where("user_id = ?", user)
                # TODO: Add bit here to strip out items created/added by current user
                self.delay.compile_and_send_email(@queueItems, "daily")
            end
        end
    end


    def self.process_weekly_digests
        @date = Time.now
        @range_from = @date.last_week.beginning_of_week
        @range_to = @date.last_week.end_of_week

        @users = NotificationQueueItem.distinct.pluck(:user_id)
        @users.each do |user|
            u = User.find_by_id(user)
            if !u.nil? and u.notification_frequency == 3
                @queueItems = NotificationQueueItem.where("created_at >= #{@range_from} and created_at <= #{@range_to}").where("user_id = ?", user)
                # TODO: Add bit here to strip out items created/added by current user
                self.delay.compile_and_send_email(@queueItems, "weekly")
            end
        end
    end


    def self.process_monthly_digests
        @date = Time.now
        @range_from = @date.last_month.beginning_of_month
        @range_ro = @date.last_month.end_of_month

        @users = NotificationQueueItem.distinct.pluck(:user_id)
        @users.each do |user|
            u = User.find_by_id(user)
            if !u.nil? and u.notification_frequency == 4
                @queueItems = NotificationQueueItem.where("created_at >= #{@range_from} and created_at <= #{@range_to}").where("user_id = ?", user)
                
                # TODO: Add bit here to strip out items created/added by current user
                self.delay.compile_and_send_email(@queueItems, "monthly")
            end
        end
    end


    def self.compile_and_send_email(items, digest_type = nil, user)
        if digest_type.nil?
            item = items.first
            @user = User.find_by_id(item.user_id)

            @email = @user.email
            @name = @user.name
            
            if (!user.nil? and user.id != @user.id) or user.nil?
                ImmediateMailer.as_they_happen(item).deliver
                item.destroy
            end
        else
            # send digest
            if digest_type == "daily"
                DigestMailer.daily(items).deliver_later
            elsif digest_type == "weekly"
                DigestMailer.weekly(items).deliver_later
            elsif digest_type == "monthly"
                DigestMailer.monthly(items).deliver_later
            end

            for item in items
                item.destroy
            end
        end

    end


    def self.prune_unnecessary_queue_items(attrs)
        # removes queue items
        # requires user id and either claim, prediction, or expert
        return if attrs.nil?

        if !attrs.has_key?("user_id") or (!attrs.has_key?("prediction_id") and !attrs.has_key?("claim_id") and !attrs.has_key?("expert_id"))
            return
        end

        if attrs.has_key?("prediction_id")
            query = "prediction_id = #{attrs.has_key?("prediction_id")}"
        elsif attrs.has_key?("claim_id")
            query = "claim_id = #{attrs.has_key?("claim_id")}"
        elsif attrs.has_key?("expert_id")
            query = "expert_id = #{attrs.has_key?("expert_id")}"
        end

        query += " and user_id = #{attrs["user_id"]}"

        NotificationQueueItem.where(query).each do |item|
            item.destroy
        end
    end
end