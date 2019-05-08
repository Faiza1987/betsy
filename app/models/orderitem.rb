class Orderitem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true

  def calculate_cost
    self.product.price * self.quantity
  end
end
