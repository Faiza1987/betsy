class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: {:greater_than => 0}
  validates :stock, presence: true, numericality: {:only_integer => true, :greater_than_or_equal_to => 0}

  has_and_belongs_to_many :categories
  belongs_to :user
  has_many :reviews
  has_many :orderitems
  has_many :orders, :through => orderitems

  def average_rating
    num_ratings = self.reviews.count
    return 0 if num_ratings == 0

    total = 0
    self.reviews.each do |review|
      total += review.rating
    end

    average = (total / num_ratings)
    return average
  end
end
