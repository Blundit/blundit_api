class Expert < ApplicationRecord
  extend Enumerize
  acts_as_taggable

  # TODO: Make this destroy? Or should 'destroy' simply hide the expert? 
  # TODO: Decide this app-wide
  has_many :contributions
  
  has_many :expert_claims, dependent: :destroy
  has_many :claims, -> { distinct }, :through => :expert_claims

  has_many :expert_categories, dependent: :destroy, after_add: :push_category_update_notification
  has_many :categories, -> { distinct }, :through => :expert_categories

  has_many :expert_comments, dependent: :destroy
  has_many :comments, -> { distinct }, :through => :expert_comments

  has_many :expert_predictions, dependent: :destroy
  has_many :predictions, -> { distinct }, :through => :expert_predictions

  has_many :expert_flags, dependent: :destroy
  has_many :flags, -> { distinct }, :through => :expert_flags

  has_many :expert_category_accuracies

  has_many :bona_fides

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/experts/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/


  attr_reader :contributions_list
  def contributions_list
    {
      created_expert: "Created Expert",
      edited_expert: "Edited Expert",
      destroyed_expert: "Destroyed Expert",
      added_category: "Added Category to Expert",
      removed_category: "Removed Category from Expert",
      added_comment: "Added Comment to Expert",
      added_claim: "Added Claim to Expert",
      removed_claim: "Removed Claim from Expert",
      added_prediction: "Added Prediction to Expert",
      removed_prediction: "Removed Prediction from Expert",
      flagged_expert: "Flagged Expert",
      added_bona_fide: "Added Bona Fide to Expert",
      removed_bona_fide: "Removed Bona Fide from Expert",
      added_tag: "Added Tag to Expert",
      removed_tag: "Removed Tag From Expert"
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
  

  after_save :push_update_notifications
  def push_update_notifications
      # TODO: Only send this when certain things are changed.
      attrs = {
          expert_id: self.id,
          message: self.previous_changes,
          item_type: "expert_updated"
      }
      NotificationQueue::delay.process(attrs)
  end


  def push_category_update_notification(obj)
    #TODO: Also call when removed?
    attrs = {
      expert_id: self.id,
      category_id: obj.id,
      message: "category_added",
      item_type: "expert_updated"
    }
    
    NotificationQueue::delay.process(attrs)
  end


  scope :do_search, -> (q) do
    qstr = q.split(" ")
    fields = %w(experts.name experts.description tags.name)
    clause = []
    
    qstr.each do |qs|
      if !STOP_WORDS.include?(qs.downcase)
        q = "'%#{qs.downcase}%'"
        clause << fields.map{ |f| "LOWER(#{f}) LIKE #{q}"}.join(" OR ")
      end
    end
    
    select('distinct experts.*').joins("LEFT JOIN taggings on experts.id = taggings.taggable_id")
      .joins("LEFT JOIN tags on tags.id = taggings.tag_id")
      .where(clause.join(" OR "))
  end


  def calc_accuracy
    @number_of_correct_predictions = self.predictions.where(status: 1).where("vote_value >= #{ENV['prediction_vote_threshold'].to_f}").count
    @number_of_predictions = self.predictions.where(status: 1).count

    @number_of_correct_claims = self.claims.where(status: 1).where("vote_value >= #{ENV['claim_vote_threshold'].to_f}").count
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

    calc_category_accuracies
  end


  def calc_category_accuracies
    calc_prediction_category_accuracies
    calc_claim_category_accuracies
  end


  def calc_prediction_category_accuracies
    @category_accuracies = {}

    self.predictions.where({ status: 1 }).each do |prediction|
      prediction.categories.each do |category|
        @key = "_#{category.id}"

        if !@category_accuracies.has_key?(@key)
          @category_accuracies[@key] = { correct: 0, incorrect: 0, id: category.id  }
        end

        if prediction.vote_value >= ENV['prediction_vote_threshold'].to_f
          @category_accuracies[@key][:correct] += 1
        else
          @category_accuracies[@key][:incorrect] += 1
        end
      end
    end

    @category_accuracies.each do |key, value|
      @category_accuracy = self.expert_category_accuracies.where({ category_id: value[:id] })

      if @category_accuracy.length == 0
        @category_accuracy = ExpertCategoryAccuracy.create({ expert_id: self.id, category_id: value[:id] })
      else
        @category_accuracy = @category_accuracy.first
      end

      @category_accuracy.correct_predictions = value[:correct]
      @category_accuracy.incorrect_predictions = value[:incorrect]

      if value[:correct] > 0 or value[:incorrect] > 0
        @category_accuracy.prediction_accuracy = value[:correct].to_f / (value[:correct].to_f + value[:incorrect].to_f)
      end

      if value[:correct] > 0 or value[:incorrect] > 0 or @category_accuracy.incorrect_claims > 0 or @category_accuracy.correct_claims > 0
        @category_accuracy.overall_accuracy = (value[:correct].to_f + @category_accuracy.correct_claims.to_f) / (value[:correct].to_f + value[:incorrect].to_f + @category_accuracy.correct_claims.to_f + @category_accuracy.incorrect_claims.to_f)
      end

      @category_accuracy.save
    end
  end


  def calc_claim_category_accuracies
    @category_accuracies = {}

    self.claims.where({ status: 1 }).each do |claim|
      claim.categories.each do |category|
        @key = "_#{category.id}"

        if !@category_accuracies.has_key?(@key)
          @category_accuracies[@key] = { correct: 0, incorrect: 0, id: category.id  }
        end

        if claim.vote_value >= ENV['claim_vote_threshold'].to_f
          @category_accuracies[@key][:correct] += 1
        else
          @category_accuracies[@key][:incorrect] += 1
        end
      end
    end

    @category_accuracies.each do |key, value|
      @category_accuracy = self.expert_category_accuracies.where({ category_id: value[:id] })

      if @category_accuracy.length == 0
        @category_accuracy = ExpertCategoryAccuracy.create({ expert_id: self.id, category_id: value[:id] })
      else
        @category_accuracy = @category_accuracy.first
      end

      @category_accuracy.correct_claims = value[:correct]
      @category_accuracy.incorrect_claims = value[:incorrect]

      if value[:correct] + value[:incorrect] > 0
        @category_accuracy.claim_accuracy = value[:correct].to_f / (value[:correct].to_f + value[:incorrect].to_f)
      else
      end

      if (value[:correct] + value[:incorrect] + @category_accuracy.incorrect_predictions + @category_accuracy.correct_predictions) > 0
        @category_accuracy.overall_accuracy = (value[:correct].to_f + @category_accuracy.correct_predictions.to_f) / (value[:correct].to_f + value[:incorrect].to_f + @category_accuracy.correct_predictions.to_f + @category_accuracy.incorrect_predictions.to_f)
      end

      @category_accuracy.save
    end
  end


  def comments_count
      return self.expert_comments_count
  end


  def add_category_if_necessary (id, source)
    return false if self.categories.where({ id: id }).count > 0

    self.claims.each do |claim|
      if claim.categories.where({ id: id }).count > 0
        return false
      end
    end

    self.predictions.each do |prediction|
      if prediction.categories.where({ id: id}).count > 0
        return false
      end
    end

    @category = Category.find_by_id(id)

    if !@category.nil?
      self.expert_categories << ExpertCategory.create({category_id: @category.id, source: source})
    end
  end


  def remove_category_if_possible(id)
    self.claims.each do |claim|
      if claim.categories.where({ id: id }).count > 0
        return false
      end
    end

    self.predictions.each do |prediction|
      if prediction.categories.where({ id: id}).count > 0
        return false
      end
    end

    return false if self.expert_categories.where({ source: 1 }) == 0

    self.expert_categories.where({ category_id: id }).each do |expert_category|
      expert_category.destroy
    end
  end
end
