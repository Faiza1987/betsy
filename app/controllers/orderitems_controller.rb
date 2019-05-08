class OrderitemsController < ApplicationController
  before_action :find_individual_order_item, only: [:show, :edit, :update, :destroy]

  def new
    @order_item = Orderitem.new(product_id: params[:product_id], quantity: 1)
  end

  def create
    order_id = get_order_id

    order_item = Orderitem.new(status: "pending", order_id: order_id, product_id: params[:product_id], quantity: params[:quantity])

    # is_successful = order_item.save
    # puts "order item #{order_item.errors.messages}"
    # puts "is successful #{is_successful}"
    if order_item.quantity_greater_than_stock
      flash[:status] = "failure"
      flash[:result_text] = "Can't be greater than total stock for product"
      return redirect_back(fallback_location: product_path(order_item.product_id))
    end

    if order_item.save
      existing_order = Order.find_by(id: order_item.order_id)
      existing_product = Product.find_by(id: order_item.product_id)

      existing_order.orderitem_ids << order_item.id
      existing_product.orderitem_ids << order_item.id
      flash[:result_text] = "Order item added successfully"

      redirect_to order_path(order_id)
    end
  end

  def edit
    @product_name = Product.find_by(id: @order_item.product_id).name
  end

  def update
    is_successful = @order_item.update(order_item_params)

    if is_successful
      flash[:success] = "order item updated successfully"
      redirect_to order_path(@order_item.order_id)
    else
      @order_item.errors.messages.each do |field, messages|
        flash.now[field] = messages
      end
      render :edit, status: :bad_request
    end
  end

  def destroy
    if @order_item.nil?
      flash[:error] = "That order item does not exist"
      head :not_found
    else
      @order_item.destroy
      flash[:success] = "Order item ID #{@order_item.id} deleted"
      redirect_to order_path(@order_item.order_id)
    end
  end

  private

  def find_individual_order_item
    @order_item = Orderitem.find_by(id: params[:id])
  end

  def get_order_id
    if cookies[:order_id].nil?
      cookies[:order_id] = Order.create.id
      return cookies[:order_id]
    else
      return cookies[:order_id]
    end
  end

  def order_item_params
    return params.require(:orderitem).permit(:quantity)
  end
end
