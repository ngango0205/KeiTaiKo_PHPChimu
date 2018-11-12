class Review < ApplicationRecord
  ATTRIBUTES_PARAMS =
    %i(name screen_size operator_system_id cpu battery brand_id price
    review picture).freeze

  has_many :liked, class_name: Like.name, dependent: :destroy
  has_many :liked_user, through: :liked, source: :user
  has_many :commented, class_name: Comment.name, dependent: :destroy
  has_many :commented_user, through: :commented, source: :user
  has_many :comments

  belongs_to :user
  belongs_to :brand
  belongs_to :operator_system

  mount_uploader :picture, PictureUploader

  validates :name, presence: true
  validates :user_id, presence: true
  validates :brand_id, presence: true
  validates :review, length: {maximum: 500}

  ratyrate_rateable "original_score"

  def self.checked_review
    where is_confirm: true
  end

  def self.unchecked_review
    where is_confirm: false
  end

end
