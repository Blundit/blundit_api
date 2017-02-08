class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_comments, dependent: :destroy
  has_many :comments, :through => :user_comments

  has_many :user_contributions, dependent: :destroy
  has_many :contributions, :through => :user_contributions

  has_many :user_experts, dependent: :destroy
  has_many :experts, :through => :user_experts

  has_many :user_flags, dependent: :destroy
  has_many :flags, :through => :user_flags

  has_many :user_claims, dependent: :destroy
  has_many :claims, :through => :user_claims

  has_many :user_predictions, dependent: :destroy
  has_many :predictions, :through => :user_predictions

  has_many :user_votes, dependent: :destroy
  has_many :votes, :through => :user_votes
end
