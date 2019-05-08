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
end
