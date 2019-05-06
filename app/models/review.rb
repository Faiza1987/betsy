class Review < ApplicationRecord
  validates :rating, presence: true, numericality: {only_integer: true, greater_than: 0, less_than: 6}
  belongs_to :product
end
