class Claim < ApplicationRecord
    has_many :contributions
    
    has_many :claim_experts, dependent: :destroy
    has_many :experts, :through => :claim_experts

    has_many :claim_categories, dependent: :destroy
    has_many :categories, :through => :claim_categories

    has_many :claim_votes, dependent: :destroy
    has_many :votes, :through => :claim_votes

    has_many :claim_evidences, dependent: :destroy
    has_many :evidences, :through => :claim_evidences

    has_many :claim_flags, dependent: :destroy
    has_many :flags, :through => :claim_flags

    has_many :claim_comments, dependent: :destroy
    has_many :comments, :through => :claim_comments


    ## Variables
    VOTES_REQUIRED_TO_CLOSE_PREDICTION = 5
    VOTING_WINDOW = 1.day


    attr_reader :contributions_list
    def contributions_list
        {
                created_claim: "Created Claim",
                edited_claim: "Edited Claim",
                destroyed_claim: "Destroyed Claim"
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
    

    scope :search, -> (q) do
        qstr = "%#{q.downcase}%"
        fields = %w(alias name)
        clause = fields.map{|f| "LOWER(#{f}) LIKE ?"}.join(" OR ")
        where(clause, *fields.map{ qstr })
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
        if self.status == 1 and self.vote_value >= 0.5
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
        where("status = 1 and vote_value >= 0.5")
    end


    def self.incorrect_claims
        where("status = 1 and vote_value < 0.5")
    end


    def calc_votes
        self.vote_count = self.votes.length
        vote_value = 0
        
        self.votes.each do |vote|
            vote_value += vote.vote
        end

        self.vote_value = vote_value.to_f / self.votes.length
        self.save

        calc_vote_status
    end


    def vote (value = nil, user = nil)
        return "not active" if !self.active?
        return "missing params" if user.nil? or value.nil?

        # check to see if user has already voted
        user_has_already_voted = false
        self.votes.each do |vote|
            if vote.user.id == user
                user_has_already_voted = true
            end
        end

        if !user_has_already_voted
            self.votes << Vote.create({user_id: user, vote: value})
            calc_votes
        end
    end


    def calc_vote_status
        num_votes = self.votes.length
        status = 0
        if num_votes >= VOTES_REQUIRED_TO_CLOSE_PREDICTION and self.can_close
            status = 1
        end

        self.status = status
        self.save

        if status == 1
            # TODO: Post-save actions, notifications, etc.
        end
    end


    def can_close
        @can_close = true
        if (Time.now - self.created_at) > VOTING_WINDOW and self.votes.length >= VOTES_REQUIRED_TO_CLOSE_PREDICTION
            return true
        end

        return false
    end
end
