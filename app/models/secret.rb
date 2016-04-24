class Secret < ActiveRecord::Base
  belongs_to :user
  has_many :likes
  has_many :users_liked_by, through: :likes, source: :user
  validates :content, presence: true
end