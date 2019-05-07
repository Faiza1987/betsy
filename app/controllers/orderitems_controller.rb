class OrderitemsController < ApplicationController
  before_action :find_individual_order_item, only: [:show, :edit, :update, :destroy]

  def index
    @order_items = Orderitem.all
  end

  def show
    if @order_item.nil?
      flash[:error] = "Unknown order item"

      redirect_to root_path
    end
  end

  def new
    @order_item = Orderitem.new(product_id: params[:product_id], quantity: 1)
    @product_name = Product.find_by(id: params[:product_id]).name
  end

  def create
    order_id = get_order_id

    op = order_item_params
    op[:order_id] = order_id
    op[:status] = "pending"

    order_item = Orderitem.new(op)

    is_successful = order_item.save

    # test
    existing_order = Order.find_by(id: order_id)
    existing_product = Product.find_by(id: op[:product_id])

    existing_order.orderitem_ids << order_item.id
    existing_product.orderitem_ids << order_item.id

    if is_successful
      flash[:success] = "Order item added successfully"
      redirect_to product_path(order_item.product_id)
    else
      order_item.errors.messages.each do |field, messages|
        flash.now[field] = messages
      end

      render :new, status: :bad_request
    end
  end

  def edit
    @product_name = Product.find_by(id: params[:product_id]).name
  end

  def update
    is_successful = @order_item.update(order_item_params)

    if is_successful
      flash[:success] = "order item updated successfully"
      redirect_to root_path
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
      redirect_to order_path
    end
  end

  private

  def find_individual_order_item
    @order_item = Orderitem.find_by(id: params[:id])
  end

  def get_order_id
    if cookies[:order_id].nil?
      new_order = Order.create(status: "pending")
      cookies[:order_id] = new_order.id
      return cookies[:order_id]
    else
      return cookies[:order_id]
    end
  end

  def order_item_params
    return params.require(:orderitem).permit(:quantity, :product_id, :order_id, :status)
  end
end
