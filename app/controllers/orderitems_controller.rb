class OrderitemsController < ApplicationController
  before_action :find_individual_order_item, only: [:show, :edit, :update, :destroy]

  def new
    @order_item = Orderitem.new(product_id: params[:product_id], quantity: 1)
  end

  def create
    order_id = get_order_id

    order_item = Orderitem.new(status: "pending", order_id: order_id, product_id: params[:product_id], quantity: params[:quantity])

    if order_item.is_quantity_valid?
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
    else
      flash[:status] = :failure
      flash[:result_text] = "Cannot create order item"
      flash[:messages] = order_item.errors.messages

      redirect_back(fallback_location: product_path(order_item.product_id))
    end
  end

  def edit
    @product_name = Product.find_by(id: @order_item.product_id).name
  end

  def update
    if params[:orderitem][:quantity].to_i > Product.find_by(id: @order_item.product_id).stock
      flash[:status] = :failure
      flash[:result_text] = "Can't be greater than total stock for product"
      redirect_back(fallback_location: root_path)
      return
    end

    is_successful = @order_item.update(order_item_params)
    if is_successful
      flash[:success] = "order item updated successfully"
      return redirect_to order_path(@order_item.order_id)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Cannot create order item"
      flash.now[:messages] = order_item.errors.messages
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
