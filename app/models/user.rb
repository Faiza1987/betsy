class User < ApplicationRecord
  has_many :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.build_from_github(auth_hash)
    return User.new(uid: auth_hash[:uid], provider: "github", email: auth_hash["info"]["email"], username: auth_hash["info"]["name"])
  end

  def find_user_products
    return Product.where(user_id: self.id)
  end

  def total_revenue(status)
    total = 0
    products = find_user_products
    products.each do |product|
      product.orderitem_ids.each do |id|
        order_item = Orderitem.find_by(id: id)
        order = Order.find_by(id: order_item.order_id)
        if order.status == status
          total += product.price * order_item.quantity
        end
      end
    end
    return total
  end

  def count_orders(status)
    products = find_user_products
    orders = []
    products.each do |product|
      product.orderitem_ids.each do |id|
        order_item = Orderitem.find_by(id: id)
        orders.concat(Order.where(id: order_item.order_id, status: status))
      end
    end
    return orders
  end
end
