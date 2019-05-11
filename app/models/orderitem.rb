class Orderitem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { :only_integer => true, :greater_than_or_equal_to => 1 }
  validate :quantity_greater_than_stock

  def is_quantity_invalid?
    return quantity_greater_than_stock
  end

  def calculate_cost
    return self.product.price * self.quantity
  end

  def add_quantity(amount_to_add)
    self.quantity += amount_to_add
  end

  def max_quantity
    product = Product.find_by(id: self.product_id)
    return product.stock
  end

  private

  # custom validation
  def quantity_greater_than_stock
    return !self.quantity.nil? && self.quantity > Product.find_by(id: product_id).stock
  end
end
