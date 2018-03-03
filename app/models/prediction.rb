class Prediction < ApplicationRecord
    has_many :contributions

    has_many :prediction_categories, dependent: :destroy, after_add: :push_category_update_notification
    has_many :categories, :through => :prediction_categories

    has_many :prediction_comments, dependent: :destroy
    has_many :comments, :through => :prediction_comments

    has_many :prediction_evidences, dependent: :destroy
    has_many :evidences, :through => :prediction_evidences

    has_many :prediction_experts, dependent: :destroy
    has_many :experts, :through => :prediction_experts

    has_many :prediction_votes, dependent: :destroy
    has_many :votes, :through => :prediction_votes

    has_many :prediction_flags, dependent: :destroy
    has_many :flags, :through => :prediction_flags

    has_many :vote_overrides

    validates_presence_of :title

    has_attached_file :pic, styles: { medium: "300x300>", thumb: "100x100>" }
    validates_attachment_content_type :pic, content_type: /\Aimage\/.*\z/

    acts_as_taggable


    attr_reader :contributions_list
    def contributions_list
        {
            created_prediction: "Created Prediction",
            edited_prediction: "Edited Prediction",
            destroyed_prediction: "Destroyed Prediction",
            added_comment: "Added Comment to Prediction",
            added_category: "Added Category to Prediction",
            removed_category: "Removed Category from Prediction",
            added_tag: "Added Tag to Prediction",
            removed_tag: "Removed Tag From Prediction",
            added_expert: "Added Expert to Prediction",
            removed_expert: "Removed Expert from Prediction",
            voted: "Voted on Prediction",
            updated_image: "Updated Prediction Image",
            deleted_image: "Deleted Prediction Image"
        }
    end


    before_save :generate_alias
    def generate_alias
        if self.alias.nil?
            self.alias = self.title.parameterize
            if Prediction.where(alias: self.alias).count > 0
                increment = 2
                self.alias = self.title.parameterize + "-" + increment.to_s

                while Prediction.where(alias: self.alias).count > 0 do
                    increment = increment + 1
                    self.alias = self.title.parameterize + "-" + increment.to_s
                end
            end
        end
    end


    after_create :add_to_sidekiq
    def add_to_sidekiq
        params = { 
            id: self.id
        }

        @sidekiq_time = self.prediction_date.to_i + ENV['claim_voting_window'].to_i.days.to_i
        PredictionWorker.perform_at(@sidekiq_time, params)
    end


    after_save :push_update_notifications
    def push_update_notifications
        attrs = {
            prediction_id: self.id,
            message: self.previous_changes,
            item_type: "prediction_updated",
        }
        NotificationQueue::delay.process(attrs)
    end


    def push_category_update_notification(obj)
        #TODO: Also call when removed?
        attrs = {
            prediction_id: self.id,
            category_id: obj.id,
            message: "category_added",
            item_type: "prediction_updated",
        }
        
        NotificationQueue::delay.process(attrs)
    end


    scope :do_search, -> (q, p, s) do
        if !q.nil?
            qstr = q.split(" ")
        else
            qstr = [""]
        end

        fields = %w(predictions.title predictions.description tags.name)
        clause = []

        if p.to_i == 0
            @order = "created_at DESC"
        elsif p.to_i == 1
            @order = "created_at ASC"
        elsif p.to_i == 2
            @order = "updated_at DESC"
        elsif p.to_i == 3
            @order = "updated_at ASC"
        else
            @order = ""
        end        
        
        qstr.each do |qs|
            if !STOP_WORDS.include?(qs.downcase)
                q = "'%#{qs.downcase}%'"
                clause << fields.map{ |f| "LOWER(#{f}) LIKE #{q}"}.join(" OR ")
            end
        end
        
        @query = Prediction.select('distinct predictions.*').joins("LEFT JOIN taggings on predictions.id = taggings.taggable_id")
        .joins("LEFT JOIN tags on tags.id = taggings.tag_id")
        .order(@order)
        .where(clause.join(" OR ")).page(1).per(2)

        if s
            @query = @query.where("status = ?", s.to_i)
        end

        @query
    end


    def open?
        return false if self.prediction_date.nil?

        if Time.now < self.prediction_date
            return false
        end

        if Time.now >= self.prediction_date and self.status == 0
            return true
        end
        
        return true
    end


    def active?
        return false if self.prediction_date.nil?

        if Time.now >= self.prediction_date and self.status == 0
            return true
        end

        return false
    end


    def closed?
        return false if self.prediction_date.nil?

        if Time.now >= self.prediction_date and self.status == 1
            return true
        end

        return false
    end


    def correct?
        return false if self.prediction_date.nil?
        if self.status == 1 and self.vote_value >= ENV['prediction_vote_threshold'].to_f
            return true
        end
    end


    def self.open_predictions
        where("prediction_date > '#{Time.now}'")
    end


    def self.active_predictions
        where("prediction_date <= '#{Time.now}' and status = 0")
    end


    def self.closed_predictions
        where("prediction_date <= '#{Time.now}' and status = 1")
    end


    def self.correct_predictions
        where("prediction_date <= '#{Time.now}' and status = 1 and vote_value >= #{ENV['claim_vote_threshold'].to_f}")
    end


    def self.incorrect_predictions
        where("prediction_date <= '#{Time.now}' and status = 1 and vote_value < #{ENV['claim_vote_threshold'].to_f}")
    end


    def calc_votes
        vote_value = 0
        
        self.votes.each do |vote|
            vote_value += vote.vote
        end

        self.vote_value = vote_value.to_f / self.votes.length
        self.save

        calc_status
    end


    def votes_count
        return self.prediction_votes_count
    end


    def comments_count
        return self.prediction_comments_count
    end


    def vote (value = nil, user = nil)
        return "not active" if !self.active?
        return "missing params" if user.nil? or value.nil?

        if self.votes.where(user_id: user.id).count == 0
            @vote = Vote.create({user_id: user, vote: value})
            self.votes << @vote
            add_contribution(@vote, :voted)
            calc_votes
        end
    end


    def calc_status (force = nil)
        if force == true and self.status == 1
            return false
        end

        num_votes = self.votes.length
        status = 0
        if num_votes >= ENV['votes_required_to_close_prediction'].to_i and self.can_close
            status = 1
        end

        self.status = status
        self.save

        if status == 1
            # TODO: Post-save actions, notifications, etc.
            send_status_notifications
            calc_expert_accuracy
        end
    end


    def self.most_popular(since, num)
        if since == 'weekly'
          timeframe = Time.now.beginning_of_week
        elsif since == 'monthly'
          timeframe = Time.now.beginning_of_month
        elsif since == 'yearly'
          timeframe = Time.now.beginning_of_year
        end
    
        @query = Prediction.all.left_joins(:prediction_comments).group(:id).order("COUNT(prediction_comments.id) DESC").select("predictions.id as id, predictions.title as title, predictions.alias as alias, predictions.description as description, predictions.status as status, predictions.prediction_votes_count as prediction_votes_count, predictions.vote_value as vote_value, predictions.prediction_comments_count as prediction_comments_count, COUNT(prediction_comments.id) as in_timeframe")
        if !timeframe.nil?
          @query = @query.where("prediction_comments.created_at >= ?", timeframe)
        end
    
        return @query.limit(num)
      end


    def override_vote
        self.vote_value = params[:vote_value]
        self.status = 1
        if self.save
            # TODO: Post-save actions, notifications, etc.

            # add status changed notification
            send_status_notifications
            calc_expert_accuracy
        end
    end


    def send_status_notifications
        attrs = {
            prediction_id: self.id,
            item_type: "prediction_status_changed"
        }
        NotificationQueue::delay.process(attrs)

        self.experts.each do |expert|
            attrs = {
                prediction_id: self.id,
                expert_id: expert.id,
                item_type: "expert_prediction_status_changed"
            }
            NotificationQueue::delay.process(attrs)
        end
    end


    def calc_expert_accuracy
        self.experts.each do | expert |
            expert.calc_accuracy
        end
    end


    def can_close
        return false if self.prediction_date.nil?

        @can_close = true
        if (Time.now - self.prediction_date) > ENV['prediction_voting_window'].to_i.days.from_now and self.votes.length >= ENV['votes_required_to_close_prediction']
            return true
        end

        return false
    end


    def update_expert_categories(category_id, add)
        self.experts.each do |expert|
            if add == true
                expert.add_category_if_necessary(category_id, false)
            else
                expert.remove_category_if_possible(category_id)
            end
        end
    end


    def delete_image
        self.pic.clear
        self.save
    end
end
