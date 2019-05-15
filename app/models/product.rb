class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { :greater_than => 0 }
  validates :stock, presence: true, numericality: { :only_integer => true, :greater_than_or_equal_to => 0 }

  has_and_belongs_to_many :categories
  belongs_to :user
  has_many :reviews
  has_many :orderitems
  has_many :orders, :through => :orderitems

  scope :category, ->(category) { where category: category }
  scope :user, ->(user) { where user: user }

  def average_rating
    num_ratings = self.reviews.count
    return 0 if num_ratings == 0

    total = 0.0
    self.reviews.each do |review|
      total += review.rating
    end

    average = (total / num_ratings)
    return average
  end

  def self.top_three
    sorted_products = Product.all.sort { |a, b| b.average_rating <=> a.average_rating }
    return sorted_products[0..2]
  end

  def nums_sold_so_far
    count = 0
    self.orderitem_ids.each do |id|
      order_item = Orderitem.find_by(id: id)
      count += order_item.quantity
    end
    return count
  end
end
