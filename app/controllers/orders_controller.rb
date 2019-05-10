class OrdersController < ApplicationController
  before_action :require_login, only: [:index]

  def index
    user_products = Product.where(user_id: session[:user_id])

    @orders = []
    user_products.each do |product|
      product.orderitem_ids.each do |id|
        order_item = Orderitem.find_by(id: id)
        @orders << Order.find_by(id: order_item.order_id)
      end
    end

    if @orders.empty?
      flash[:message] = "You do not have any existing orders"
      redirect_to root_path
    end

    return @orders
  end

  def show
    get_order_id
    @order = Order.find_by(id: cookies[:order_id])
    if @order.nil?
      flash[:error] = "Unknown order"
      redirect_to root_path
    end
  end

  def edit
  end

  def update
    @order = Order.find_by(id: params[:id])

    @order.orderitem_ids.each do |id|
      order_item = Orderitem.find_by(id: id)
      if order_item.is_quantity_invalid?
        flash[:status] = :warning
        flash[:result_text] = "There is not enough #{Product.find_by(id: order_item.product_id).name} in stock"
        return redirect_to order_path(@order.id)
      end
      order_item_quantity = order_item.quantity
      product = Product.find_by(id: order_item.product_id)
      new_quantity = product.stock - order_item_quantity
      product.update_attributes(:stock => new_quantity)
    end

    is_successful = @order.update(order_params)

    @order.update_attributes(:status => "Paid")

    if is_successful
      flash[:result_text] = "Order was placed successully"
      cookies.delete :order_id
      redirect_to order_path(@order.id)
    else
      @order_item.errors.messages.each do |field, messages|
        flash.now[field] = messages
      end
      render :edit, status: :bad_request
    end
  end

  private

  def get_order_id
    if cookies[:order_id].nil?
      cookies[:order_id] = Order.create(status: "pending").id
      return cookies[:order_id]
    else
      return cookies[:order_id]
    end
  end

  def order_params
    return params.permit(
             :name, :email, :mailing_address,
             :credit_card_num, :card_expiration_date,
             :cvv, :billing_zip_code, :status, orderitem_ids: [],
           )
  end
end
