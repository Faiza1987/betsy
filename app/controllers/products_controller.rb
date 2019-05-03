class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  before_action :logged_in, only: [:review]
  before_action :product_merchant?, only: [:edit, :destroy]

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
        flash[:success] = "Succesfully deleted!"
        redirect_to products_path
      end
    else
      redirect_to products_path, :alert => "Must be product merchant."
    end
  end

  def review
    if @reviewer
      @review = Review.new(rating: params[:rating], description: params[:description])
      @review.product_id = params[:id]
      @review.user_id = session[:user_id]

      @product = Product.find_by(id: params[:id])

      @user = User.find_by(id: @review.user_id)

      if @user == @product.user
        flash[:error] = "Cannot review own product."
        redirect_to product_path(@review.product_id)
      else @review.save
        flash[:success] = "Review posted!"
        redirect_to product_path(@review.product_id)       end
    else
      flash[:error] = "Must be logged in."
      redirect_to product_path(id: params[:id])
    end
  end

  private

  def product_params
    return params.require(:product, :name).permit(:category, :price, :stock, :user_id, orderitem_ids: [])
  end

  def product_merchant?
    @user = User.find_by(id: session[:user_id])
    @user == @product.user
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    head :not_found unless @product
  end

  def logged_in?
    @reviewer = User.find_by(id: session[:user_id])
  end
end
