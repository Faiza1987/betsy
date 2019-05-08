class OrderitemsController < ApplicationController
  before_action :find_individual_order_item, only: [:show, :edit, :update, :destroy]

  # def index
  #   @order_items = Orderitem.all
  # end

  # def show
  #   if @order_item.nil?
  #     flash[:error] = "Unknown order item"

  #     redirect_to root_path
  #   end
  # end

  def new
    @order_item = Orderitem.new(product_id: params[:product_id], quantity: 1)
  end

  def create
    # redirect_to product_orderitems_path(params[:product_id])
    order_id = get_order_id

    # op = order_item_params
    # op[:status] = "pending"
    # op[:order_id] = order_id

    order_item = Orderitem.new(status: "pending", order_id: order_id, product_id: params[:product_id], quantity: params[:quantity])

    # order_item = Orderitem.new(adding_to_cart_params)
    # order_item.status = "pending"
    # order_item.order_id = order_id

    is_successful = order_item.save
    puts "order item #{order_item.errors.messages}"
    puts "is successful #{is_successful}"
    if is_successful
      existing_order = Order.find_by(id: order_item.order_id)
      existing_product = Product.find_by(id: order_item.product_id)

      existing_order.orderitem_ids << order_item.id
      existing_product.orderitem_ids << order_item.id

      flash[:success] = "Order item added successfully"
      # Just a low-priority thought: Do we think we NEED to nest order items routes inside of order? Why not just order/show?
      redirect_to order_path(order_id)
    else
      order_item.errors.messages.each do |field, messages|
        flash.now[field] = messages
      end

      # This is showing the view at views/orderitems/_new.html.erb, if you want it from a different directory, there is a way to do this! Look it up :)
      render :_new, status: :bad_request
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

  # def adding_to_cart_params
  #   return params.permit(:quantity, :product_id)
  # end
end
