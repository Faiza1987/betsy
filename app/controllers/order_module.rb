module CreateOrder
  def get_order_id
    if cookies[:order_id].nil?
      cookies[:order_id] = Order.create.id
      return cookies[:order_id]
    else
      return cookies[:order_id]
    end
  end
end
