class Expert < ApplicationRecord
  # extend Enumerize

  # TODO: Make this destroy? Or should 'destroy' simply hide the expert? 
  # TODO: Decide this app-wide
  has_many :contributions
  
  has_many :expert_claims, dependent: :destroy
  has_many :claims, :through => :expert_claims

  has_many :expert_categories, dependent: :destroy
  has_many :categories, :through => :expert_categories

  has_many :expert_comments, dependent: :destroy
  has_many :comments, :through => :expert_comments

  has_many :expert_predictions, dependent: :destroy
  has_many :predictions, :through => :expert_predictions

  has_many :expert_flags, dependent: :destroy
  has_many :flags, :through => :expert_flags


  attr_reader :contributions_list
  def contributions_list
    {
      created_expert: "Created Expert",
      edited_expert: "Edited Expert",
      destroyed_expert: "Destroyed Expert"
    }
  end


  before_save :generate_alias
  def generate_alias
    if self.alias.nil?
      self.alias = self.name.parameterize
      if Expert.where(alias: self.alias).count > 0
        increment = 2
        self.alias = self.name.parameterize + "-" + increment.to_s

        while Expert.where(alias: self.alias).count > 0 do
          increment = increment + 1
          self.alias = self.name.parameterize + "-" + increment.to_s
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
