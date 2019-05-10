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
    @order = Order.find_by(id: params[:id])
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
      flash.now[:status] = :failure
      flash.now[:result_text] = "Cannot place order"
      flash.now[:messages] = @order.errors.messages
      render :edit, status: :bad_request
    end
  end

  private

  def order_params
    return params.permit(
             :name, :email, :mailing_address,
             :credit_card_num, :card_expiration_date,
             :cvv, :billing_zip_code, :status, orderitem_ids: [],
           )
  end
end
