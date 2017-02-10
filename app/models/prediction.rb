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
            if Expert.where(alias: self.alias).count > 0
                increment = 2
                self.alias = self.title.parameterize + "-" + increment.to_s

                while Expert.where(alias: self.alias).count > 0 do
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
end
