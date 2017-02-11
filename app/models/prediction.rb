class Prediction < ApplicationRecord
    has_many :contributions

    has_many :prediction_categories, dependent: :destroy
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

    ## Variables
    VOTES_REQUIRED_TO_CLOSE_PREDICTION = 5


    attr_reader :contributions_list
    def contributions_list
        {
            created_contribution: "Created Contribution",
            edited_contribution: "Edited Contribution",
            destroyed_contribution: "Destroyed Contribution"
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


    scope :search, -> (q) do
        qstr = "%#{q.downcase}%"
        fields = %w(alias name)
        clause = fields.map{|f| "LOWER(#{f}) LIKE ?"}.join(" OR ")
        where(clause, *fields.map{ qstr })
    end


    def open?
        return false if self.prediction_date.nil?

        if Time.now < self.prediction_date
            return true
        end
        
        return false
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
        if self.status == 1 and self.vote_value >= 0.5
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
        where("prediction_date <= '#{Time.now}' and status = 1 and vote_value >= 0.5")
    end


    def self.incorrect_predictions
        where("prediction_date <= '#{Time.now}' and status = 1 and vote_value < 0.5")
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
        if num_votes >= VOTES_REQUIRED_TO_CLOSE_PREDICTION
            status = 1
        end

        self.status = status
        self.save

        if status == 1
            # TODO: Post-save actions, notifications, etc.
        end
    end


    def self.votes_required_to_close
        # TODO: Make this number variable, based on user count and interaction
        # The quicker the votes, the higher the number of votes required.
        # Or time-based? Who knows. 
        # Open forever until minimal number of votes, but fewer votes affects
        # the duration?
        VOTES_REQUIRED_TO_CLOSE_PREDICTION
    end

end
