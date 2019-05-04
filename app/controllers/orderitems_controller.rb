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
    @order_item = Orderitem.new(quantity: 0)
  end

  def create
    order_id = get_order_id

    op = order_item_params
    op[:order_id] = order_id
    op[:product_id] = params[:product_id]
    order_item = Orderitem.new(op)

    is_successful = order_item.save

    # test
    existing_order = Order.find_by(id: order_id)

    existing_order.orderitem_ids << order_item

    if is_successful
      flash[:success] = "Order item added successfully"
      redirect_to orderitem_path(order_item.id)
    else
      order_item.errors.messages.each do |field, messages|
        flash.now[field] = messages
      end

      render :new, status: :bad_request
    end
  end

  def edit
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
      cookies[:order_id] = Order.create.id
      return cookies[:order_id]
    else
      return cookies[:order_id]
    end
  end

  def order_item_params
    return params.require(:orderitem).permit(:quantity, :product_id, :order_id)
  end
end
