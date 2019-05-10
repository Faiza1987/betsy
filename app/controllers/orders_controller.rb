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
      @order_item.errors.messages.each do |field, messages|
        flash.now[field] = messages
      end
      render :edit, status: :bad_request
    end

    # NEW CODE
    if @order.orderitem_ids.length != 0
      @specific_product = OrderItem.where(order_id: @order.id)
    
      @specific_product.orderitem_ids.each do |order|
        if order.product.retired
          order.destroy
        end
      end
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
