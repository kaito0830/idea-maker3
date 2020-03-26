class Idea < ApplicationRecord
  validates :title, presence: true
  validates :info, presence: true
  validates :price, presence: true

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments

  def self.search(search)
    return Idea.all() unless search
    Idea.where('title LIKE(?)', "%#{search}%")
  end
end

