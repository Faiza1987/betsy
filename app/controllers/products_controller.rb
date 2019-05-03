class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    if params[:category]
      @title = "#{params[:category].upcase}"
      @products = Product.where(:category => params[:category])
      @products = @products.order(:name)
    else
      @title = "All Products"
      @products = Product.all.order(:name)
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = session[:user_id]

    if @product.save
      flash[:success] = "Product added!"
      redirect_to product_path(@product.id)
    else
      flash.now[:error] = "Failed to add product, check product data."
      render :new, status: :bad_request
    end
  end

  def show
    @orderitem = OrderItem.new
  end

  def edit
    unless product_merchant?
      redirect_to products_path, :alert => "Must be product merchant."
    end
  end

  def update
    if @product.update(product_params)
      flash[:success] = "Update successful!"
      redirect_to product_path(@product.id)
    else
      flash[:error] = "Update failed, please check product data."
      render :edit, status: :bad_request
    end
  end

  def destroy
    if product_merchant?
      if @product.destroy
        flash[:status] = :success
        flash[:success] = "Delete successful!"
        redirect_to products_path
      end
    else
      redirect_to products_path, :alert => "Must be product merchant."
    end
  end

  private

  def product_params
    return params.require(:product, :name).permit(:category, :price, :stock, :user_id)
  end

  def product_merchant?
    @user = User.find_by(id: session[:user_id])
    @user == @product.user
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    head :not_found unless @product
  end
end
