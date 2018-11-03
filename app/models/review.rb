require "elasticsearch/model" 
class Review < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  ATTRIBUTES_PARAMS =
    %i(name screen_size operator_system_id cpu battery brand_id price
    reivew picture).freeze

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

  settings index: {number_of_shards: 1} do
    mappings dynamic: "false" do
      indexes :name, analyzer: "english"
      indexes :about, analyzer: "english"
    end
  end
  class << self
    def search query
      __elasticsearch__.search(
        {
          query: {
            multi_match: {
              query: query,
              fields: ["name"]
            }
          }
        }
      )
    end
  end
end

Review.__elasticsearch__.client.indices.delete index: Review.index_name rescue nil
Review.__elasticsearch__.client.indices.create \
  index: Review.index_name,
  body: { settings: Review.settings.to_hash, mappings: Review.mappings.to_hash }
Review.import
