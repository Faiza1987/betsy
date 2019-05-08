class Orderitem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { :only_integer => true, :greater_than_or_equal_to => 1 }
  validate :quantity_greater_than_stock

  def quantity_greater_than_stock
    if !quantity.nil? && quantity > Product.find_by(id: product_id).stock
      errors.add(:quantity, "can't be greater than total stock for product")
    end
  end
end
