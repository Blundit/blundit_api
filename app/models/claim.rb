class Claim < ApplicationRecord
    has_many :contributions
    
    has_many :claim_experts, dependent: :destroy
    has_many :experts, -> { distinct }, through: :claim_experts

    has_many :claim_categories, dependent: :destroy, after_add: :push_category_update_notification
    has_many :categories, -> { distinct }, :through => :claim_categories

    has_many :claim_votes, dependent: :destroy
    # has_many :votes, -> { distinct }, :through => :claim_votes

    has_many :claim_evidences, dependent: :destroy
    has_many :evidences, -> { distinct }, :through => :claim_evidences

    has_many :claim_flags, dependent: :destroy
    has_many :flags, -> { distinct }, :through => :claim_flags

    has_many :claim_comments, dependent: :destroy
    has_many :comments, -> { distinct }, :through => :claim_comments

    has_many :vote_overrides
    has_many :vote_sets

    validates_presence_of :title

    has_attached_file :pic, styles: { medium: "300x300>", thumb: "100x100>" }
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
            updated_image: "Updated Claim Image",
            deleted_image: "Deleted Claim Image"
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


    after_create :create_vote_set, :add_to_sidekiq
    def add_to_sidekiq
        params = {
            id: self.id
        }

        ClaimWorker.perform_at(ENV['claim_voting_window'].to_i.days.from_now, params)
    end

    def create_vote_set(user_id = nil, reason = "Claim Created and Active")
        disable_other_vote_sets
        @vote_set = VoteSet.new
        @vote_set.user_id = user_id
        @vote_set.reason = reason
        @vote_set.claim_id = self.id
        @vote_set.active = true

        @vote_set.save

        self.vote_sets << @vote_set
        self.vote_set_id = @vote_set.id
    end


    def disable_other_vote_sets
        self.vote_sets.each do |set|
            set.active = false
            set.save
        end
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


    def votes
        @vote_set = current_vote_set
        if @vote_set.nil?
            return Vote.where({claim_id: self.id })
        else
            @vote_set.votes
        end
    end


    def all_votes
        Vote.where({claim_id: self.id})
    end


    def current_vote_set
        if self.vote_set_id.nil?
            return nil
        end

        VoteSet.where((self.vote_set_id)
    end
    

    scope :do_search, -> (q, p, s) do
        if !q.nil?
            qstr = q.split(" ")
        else
            qstr = [""]
        end
        fields = %w(claims.title claims.description tags.name)
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
        
        @query = Claim.select('distinct claims.*').joins("LEFT JOIN taggings on claims.id = taggings.taggable_id")
        .joins("LEFT JOIN tags on tags.id = taggings.tag_id")
        .order(@order)
        .where(clause.join(" OR ")).page(1).per(2)
        if s
            @query = @query.where("status = ?", s.to_i)
        end

        @query
    end


    def active?
        return true if self.status == 0
        return false
    end


    def closed?
        return true if self.status == 1
        return false
    end


    def is_true?
        return true if self.status == 1 and vote_winner[:type] == "true"
        return false
    end

    def is_false?
        return true if self.status == 1 and vote_winner[:type] == "false"
        return false
    end

    def is_unknown?
        return true if self.status == 1 and vote_winner[:type] == "unknown"
        return false
    end

    def is_unknowable?
        return true if self.status == 1 and vote_winner[:type] == "unknowable"
        return false
    end


    def self.active_predictions
        where("status = 0")
    end


    def self.closed_claims
        where("status = 1")
    end


    def self.correct_claims
        where("status = 1 and vote_value = 'true'")
    end


    def self.incorrect_claims
        where("status = 1 and vote_value = 'false'")
    end


    def self.unknown_claims
        where("status = 1 and vote_value = 'unknown'")
    end


    def self.unknowable_claims
        where("status = 1 and vote_value = 'unknowable'")
    end


    def calc_votes
        self.vote_value = vote_winner[:type]
        self.save

        calc_status
    end

    def votes_count
        return self.claim_votes_count
    end

    def comments_count
        return self.claim_comments_count
    end

    def self.most_popular(since, num)
        if since == 'weekly'
            timeframe = Time.now.beginning_of_week
        elsif since == 'monthly'
            timeframe = Time.now.beginning_of_month
        elsif since == 'yearly'
            timeframe = Time.now.beginning_of_year
        end
        @query = Claim.where('claim_comments_count > 0').left_joins(:claim_comments).group(:id).order("COUNT(claim_comments.id) DESC").select("claims.id as id, claims.title as title, claims.alias as alias, claims.description as description, claims.status as status, claims.claim_votes_count as claim_votes_count, claims.vote_value as vote_value, claims.claim_comments_count as claim_comments_count, COUNT(claim_comments.id) as in_timeframe")
        if timeframe
            @query = @query.where("claim_comments.created_at >= ?", timeframe)
        end
        return @query
    end


    def vote (value = nil, user = nil)
        return "missing params" if user.nil? or value.nil?
        @vote = Vote.create({
            user_id: user, 
            is_true: (value == "true" ? true : false),
            is_false: (value == "false" ? true : false), 
            is_unknown: (value == "unknown" ? true : false), 
            is_unknowable: (value == "unknowable" ? true : false),
            vote_set: self.vote_set_id
          })
          self.votes << @vote
        
        add_contribution(@claim, :voted)
        calc_votes
    end


    def active_vote_set
        if self.vote_set_id.nil?
            return self.vote_set_id
        end
        
        return self.vote_sets.where({active: true}).first.id
    end


    def vote_tally
        return [
          { type: "true", value: self.votes.where({is_true: true, vote_set_id: active_vote_set}).count },
          { type: "false", value: self.votes.where({is_false: true, vote_set_id: active_vote_set}).count },
          { type: "unknown", value: self.votes.where({is_unknown: true, vote_set_id: active_vote_set}).count },
          { type: "unknowable", value: self.votes.where({is_unknowable: true, vote_set_id: active_vote_set}).count }
        ]
    end

    def vote_winner
        return votes.max_by{|k| k[:value] }
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

        self.status = 1
        self.save

        if status == 1
            # TODO: Post-save actions, notifications, etc.
            self.vote_set_id = nil
            self.save

            @vote_set = self.vote_sets.last
            @vote_set.active = false
            @vote_set.save

            # add status changed notification
            send_status_notifications
            calc_expert_accuracy
        end
    end

    def override_vote(val)
        self.vote_value = val
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
        if (Time.now - self.created_at) > ENV['claim_voting_window'].to_i.days.from_now and self.votes.length >= ENV['votes_required_to_close_claim']
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
