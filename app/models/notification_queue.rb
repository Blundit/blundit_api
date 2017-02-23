class NotificationQueue < ApplicationRecord
    def self.process(attrs)
        if attrs.has_key?("claim_id")
            query = "claim_id = #{attrs["claim_id"]}"
        elsif attrs.has_key?("prediction_id")
            query = "prediction_id = #{attrs["prediction_id"]}"
        elsif attrs.has_key?("expert_id")
            query = "expert_id = #{attrs["expert_id"]}"
        end

        @bookmarks = Bookmark.where(query)

        @bookmarks.each do |bookmark|
            if bookmark.user.notification_frequency == 1
                @newItem = add_to_notification_queue(attrs)
                self.delay.compile_and_send_email([@newItem])
            else
                self.delay.add_to_notification_queue(attrs)
            end

            bookmark.update({ has_update: true })
        end
    end


    def add_to_notification_queue(attrs)
        # TODO: Create notification queue
        @item = NotificationQueueItem.create(attrs)
        return item
    end


    def self.process_daily_digests(attrs)
        @date = attrs["date"].to_time
        @range_from = @date.beginning_of_day
        @range_to = @date.end_of_day

        @queueItems = NotificationQueueItem.where("created_at >= #{@range_from} and created_at <= #{@range_to}").where("user_id = ?", attrs["user_id"])
        self.delay.compile_and_send_email(@queueItems)
    end


    def self.process_weekly_digests(attrs)
        @date = attrs["date"].to_time
        @range_from = @date.beginning_of_week
        @range_to = @date.end_of_week

        @queueItems = NotificationQueueItem.where("created_at >= #{@range_from} and created_at <= #{@range_to}").where("user_id = ?", attrs["user_id"])
        self.delay.compile_and_send_email(@queueItems)
    end


    def self.process_monthly_digests(attrs)
        @date = attrs["date"].to_time
        @range_from = @date.beginning_of_month
        @range_ro = @date.end_of_month

        @queueItems = NotificationQueueItem.where("created_at >= #{@range_from} and created_at <= #{@range_to}").where("user_id = ?", attrs["user_id"])
        self.delay.compile_and_send_email(@queueItems, attrs)
    end


    def self.compile_and_send_email(items)
        items.each do |item|
            @user = User.find(item.user_id)

            @email = @user.email
            @name = @user.name

            # TODO: generate email here
            # if multiple items, use items to build a list of absolute links
            # if single item, display content
            # add links to email text
            # add to actionmailer using sidekiq?
            # delete items from the queue after sending in email

            if item.type == "new_claim_comment"
                ClaimMailer.new_comment(item).deliver_later
            elsif item.type == "claim_updated"
                ClaimMailer.claim_updated(item).deliver_later
            elsif item.type == "expert_added_to_claim"
                ClaimMailer.expert_added_to_claim(item).deliver_later
            elsif item.type == "new_prediction_comment"
                PredictionMailer.new_comment(item).deliver_later
            elsif item.type == "claim_updated"
                PredictionMailer.prediction_updated(item).deliver_later
            elsif item.type == "expert_added_to_prediction"
                PredictionMailer.expert_added_to_prediction(item).deliver_later
            elsif item.type == "new_expert_comment"
                ExpertMailer.new_comment(item).deliver_later
            elsif item.type == "prediction_updated"
                ExpertMailer.prediction_updated(item).deliver_later
            elsif item.type == "claim_added_to_expert"
                ExpertMailer.claim_added_to_expert(item).deliver_later
            elsif item.type == "prediction_added_to_expert"
                ExpertMailer.prediction_added_to_expert(item).deliver_later
            end

            # clear out sent notifications
            item.destroy
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

        NotificationQueueItems.where(query).each do |item|
            item.destroy
        end
    end
end