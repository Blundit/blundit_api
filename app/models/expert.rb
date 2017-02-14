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

  has_many :publications


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
    fields = %w(alias name description)
    clause = fields.map{|f| "LOWER(#{f}) LIKE ?"}.join(" OR ")
    where(clause, *fields.map{ qstr })
  end


  def calc_accuracy
    @number_of_correct_predictions = self.predictions.where(status: 1).where('vote_value >= 0.5').count
    @number_of_predictions = self.predictions.where(status: 1).count

    @number_of_correct_claims = self.claims.where(status: 1).where('vote_value >= 0.5').count
    @number_of_claims = self.claims.where(status: 1).count

    if @number_of_predictions > 0
      self.prediction_accuracy = @number_of_correct_predictions / @number_of_predictions
    end

    if @number_of_claims > 0
      self.claim_accuracy = @number_of_correct_claims / @number_of_claims
    end

    if @number_of_predictions > 0 and @number_of_claims > 0
      self.accuracy = (@number_of_correct_claims + @number_of_correct_predictions) / (@number_of_predictions + @number_of_claims)
    elsif @number_of_predictions > 0 and @number_of_claims == 0
      self.accuracy = self.prediction_accuracy
    elsif @number_of_predictions == 0 and @number_of_claims > 0
      self.accuracy = self.claim_accuracy
    end
    
    self.save
  end
end
