class OrdersController < ApplicationController
  before_action :require_login, except: [:show]

  def index
    user_products = Product.find_by(user_id: session[:user_id])
    @orders = []
    user_products.each do |product|
      product.orderitem_ids.each do |id|
        order_item = Orderitem.find_by(id: id)
        @orders << Order.find_by(id: order_item.order_id)
      end
    end

    if @orders.empty?
      flash[:message] = "You do not have any existing orders"
      # need to figure out where we want to redirect to be most user-friendly
      redirect_to root_path
    end

    return @orders
  end

  def show
    if @order.nil?
      flash[:error] = "Unknown order"
      redirect_to root_path
    end
  end

  def edit
  end

  def update
    is_successful = @order.update(order_params)

    @order.orderitem_ids.each do |id|
      order_item = Orderitem.find_by(id: id)
      order_item_quantity = order_item.quantity
      product = Product.find_by(id: order_item.product_id)
      new_quantity = product.stock - order_item_quantity
      product.update(stock: new_quantity)
    end

    if is_successful
      flash[:success] = "Order was placed successully"
      redirect_to order_path(@order.id)
    else
      @order_item.errors.messages.each do |field, messages|
        flash.now[field] = messages
      end
      render :edit, status: :bad_request
    end
  end

  private

  def order_params
    return params.require(:order).permit(
             :name, :email, :mailing_address,
             :credit_card_num, :card_expiration_date,
             :cvv, :billing_zip_code, orderitem_ids: [],
           )
  end
end
