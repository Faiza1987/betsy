class Order < ApplicationRecord
  has_many :orderitems
  has_many :products, :through => :orderitems

  validates :name, presence: true, if: :paid?
  validates :email, presence: true, if: :paid?
  validates :mailing_address, presence: true, if: :paid?
  validates :credit_card_num, presence: true, length: {in: 16..16}, if: :paid?
  validates :card_expiration_date, presence: true, if: :paid?
  validates :cvv, presence: true, if: :paid?
  validates :billing_zip_code, presence: true, length: {in: 5..5}, if: :paid?

  def calculate_total
    total = 0.00
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
