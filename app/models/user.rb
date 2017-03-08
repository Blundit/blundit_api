class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
          
  include DeviseTokenAuth::Concerns::User
  extend Enumerize
  extend ActiveModel::Naming


  has_many :user_comments, dependent: :destroy
  has_many :comments, -> { distinct }, :through => :user_comments

  has_many :user_contributions, dependent: :destroy
  has_many :contributions, -> { distinct }, :through => :user_contributions

  has_many :user_experts, dependent: :destroy
  has_many :experts, -> { distinct }, :through => :user_experts

  has_many :user_flags, dependent: :destroy
  has_many :flags, -> { distinct }, :through => :user_flags

  has_many :user_claims, dependent: :destroy
  has_many :claims, -> { distinct }, :through => :user_claims

  has_many :user_predictions, dependent: :destroy
  has_many :predictions, -> { distinct }, :through => :user_predictions

  has_many :votes
  has_many :bookmarks, -> { distinct }, dependent: :destroy

  enumerize :notification_frequency, in: {:as_they_happen => 1, :daily => 2, :weekly => 3, :monthly => 4, :none => 0}, default: 1

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/users/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/


  def name
    @name = "#{self.first_name} #{self.last_name}"
  end
  

  VOTING_RANK_OPTIONS = [
    { min: 0, max: 25, rank: "newbie", badge: "" },
    { min: 26, max: 50, rank: "average", badge: "" },
    { min: 51, max: 75, rank: "pro", badge: "" },
  ]


  def voting_rank
    @votes = self.votes_count
    @votes = 0 if self.votes_count.nil?

    @rank = false

    VOTING_RANK_OPTIONS.each do |r| 
      if @votes >= r[:min] and @votes <= r[:max]
        @rank = r
      end
    end

    return @rank
  end


  def comments_count
    return self.user_comments_count
  end
  

  def comments_rank

  end


  def claims_rank

  end


  def experts_rank

  end


  def predictions_rank

  end

end
