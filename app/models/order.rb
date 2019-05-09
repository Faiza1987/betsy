class Order < ApplicationRecord
  has_many :orderitems
  has_many :products, :through => :orderitems
  validates :status, presence: true

  # validates :name, presence: true
  # validates :email, presence: true
  # validates :mailing_address, presence: true
  # validates :credit_card_num, presence: true, length: {in: 16..16}
  # validates :card_expiration_date, presence: true
  # validates :cvv, presence: true
  # validates :billing_zip_code, presence: true, length: {in: 5..5}

  def calculate_total
    total = 0
    self.orderitems.each do |item|
      total += item.calculate_cost
    end
    total
  end

  def find_order_item_merchants
    item_merchants = []
    self.orderitems.each do |item|
      item_merchants << item.product.user_id
    end
    return item_merchants
  end

  def order_complete?
    self.orderitems.each do |item|
      if item.status != "Shipped"
        return false
      end
    end
    return true
  end
end
