require "elasticsearch/model" 
class User < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  ratyrate_rater
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :reviews
  has_many :liked, class_name: Like.name, dependent: :destroy
  has_many :liked_review, through: :liked, source: :review
  has_many :commented, class_name: Comment.name, dependent: :destroy
  has_many :commented_review, through: :commented, source: :review
  has_many :likes
  has_many :comments

  mount_uploader :picture, PictureUploader

  validates :email, presence: true, 
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :name, presence: true, length: {maximum: 30, minimum: 6}

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
              fields: ["name^5", "email^2"]
            }
          }
        }
      )
    end
  end
end

User.__elasticsearch__.client.indices.delete index: User.index_name rescue nil
User.__elasticsearch__.client.indices.create \
  index: User.index_name,
  body: { settings: User.settings.to_hash, mappings: User.mappings.to_hash }
User.import
