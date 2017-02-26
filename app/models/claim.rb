class Claim < ApplicationRecord
    has_many :contributions
    
    has_many :claim_experts, dependent: :destroy
    has_many :experts, -> { distinct }, through: :claim_experts

    has_many :claim_categories, dependent: :destroy, after_add: :push_category_update_notification
    has_many :categories, -> { distinct }, :through => :claim_categories

    has_many :claim_votes, dependent: :destroy
    has_many :votes, -> { distinct }, :through => :claim_votes

    has_many :claim_evidences, dependent: :destroy
    has_many :evidences, -> { distinct }, :through => :claim_evidences

    has_many :claim_flags, dependent: :destroy
    has_many :flags, -> { distinct }, :through => :claim_flags

    has_many :claim_comments, dependent: :destroy
    has_many :comments, -> { distinct }, :through => :claim_comments

    validates_presence_of :title

    has_attached_file :pic, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/claims/missing.png"
    validates_attachment_content_type :pic, content_type: /\Aimage\/.*\z/

    acts_as_taggable

    attr_reader :contributions_list
    def contributions_list
        {
            created_claim: "Created Claim",
            edited_claim: "Edited Claim",
            destroyed_claim: "Destroyed Claim",
            added_comment: "Added Comment to Claim",
            added_category: "Added Category to Claim",
            removed_category: "Removed Category from Claim",
            added_expert: "Added Expert to Claim",
            removed_expert: "Removed Expert from Claim",
            added_tag: "Added Tag to Claim",
            removed_tamg: "Removed Tag From Claim",
            voted: "Voted on Claim",
        }
    end


    before_save :generate_alias
    def generate_alias
        if self.alias.nil?
            self.alias = self.title.parameterize
            if Claim.where(alias: self.alias).count > 0
                increment = 2
                self.alias = self.title.parameterize + "-" + increment.to_s

                while Claim.where(alias: self.alias).count > 0 do
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

        ClaimWorker.perform_at(ENV['claim_voting_window'].to_i.days.from_now, params)
    end


    after_save :push_update_notifications
    def push_update_notifications
        attrs = {
            claim_id: self.id,
            message: self.previous_changes,
            item_type: "claim_updated"
        }
        NotificationQueue::delay.process(attrs)
    end


    def push_category_update_notification(obj)
        #TODO: Also call when removed?
        attrs = {
            claim_id: self.id,
            category_id: obj.id,
            message: "category_added",
            item_type: "claim_updated"
        }
        
        NotificationQueue::delay.process(attrs)
    end
    

    scope :do_search, -> (q) do
        qstr = q.split(" ")
        fields = %w(claims.title claims.description tags.name)
        clause = []
        
        qstr.each do |qs|
        if !STOP_WORDS.include?(qs.downcase)
            q = "'%#{qs.downcase}%'"
            clause << fields.map{ |f| "LOWER(#{f}) LIKE #{q}"}.join(" OR ")
        end
        end
        
        select('distinct claims.*').joins("LEFT JOIN taggings on claims.id = taggings.taggable_id")
        .joins("LEFT JOIN tags on tags.id = taggings.tag_id")
        .where(clause.join(" OR "))
    end


    def active?
        return true if self.status == 0
        return false
    end


    def closed?
        return true if self.status == 1
        return false
    end


    def correct?
        return false if self.prediction_date.nil?
        if self.status == 1 and self.vote_value >= ENV['claim_vote_threshold'].to_f
            return true
        end
    end


    def self.active_predictions
        where("status = 0")
    end


    def self.closed_claims
        where("status = 1")
    end


    def self.correct_claims
        where("status = 1 and vote_value >= #{ENV['claim_vote_threshold'].to_f}")
    end


    def self.incorrect_claims
        where("status = 1 and vote_value < #{ENV['claim_vote_threshold'].to_f}")
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
        return self.claim_votes_count
    end

    def comments_count
        return self.claim_comments_count
    end


    def vote (value = nil, user = nil)
        return "not active" if !self.active?
        return "missing params" if user.nil? or value.nil?

        if self.votes.where(user_id: user.id).count == 0
            @vote = Vote.create({user_id: user, vote: value})
            self.votes << @vote
            add_contribution(@claim, :voted)
            calc_votes
        end
    end


    def calc_status (force = nil)
        if force == true and self.status == 1
            return false
        end

        num_votes = self.votes.length
        status = 0
        if num_votes >= ENV['votes_required_to_close_claim'].to_i and self.can_close
            status = 1
        end

        self.status = status
        self.save

        if status == 1
            # TODO: Post-save actions, notifications, etc.

            # add status changed notification
            send_status_notifications
            calc_expert_accuracy
        end
    end


    def send_status_notifications
        attrs = {
            claim_id: self.id,
            item_type: "claim_status_changed"
        }
        NotificationQueue::delay.process(attrs)

        self.experts.each do |expert|
            attrs = {
                claim_id: self.id,
                expert_id: expert.id,
                item_type: "expert_claim_status_changed"
            }
            NotificationQueue::delay.process(attrs)
        end
    end


    def calc_expert_accuracy
        self.experts.each do |expert|
            expert.calc_accuracy
        end
    end


    def can_close
        @can_close = true
        if (Time.now - self.created_at) > ENV['voting_window'].to_i.days.from_now and self.votes.length >= VOTES_REQUIRED_TO_CLOSE_PREDICTION
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
end
