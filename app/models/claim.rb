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
end
