class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy, :retire_product]
  before_action :require_login, only: [:new, :create, :edit, :update]

  def index
    @products = Product.all
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
      flash.now[:status] = :failure
      flash.now[:result_text] = "Cannot create product"
      flash.now[:messages] = @product.errors.messages

      render :new, status: :bad_request
    end
  end

  def show
    if @product.nil?
      flash[:error] = "Unknown product"
      redirect_to products_path
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      flash[:error] = "Unknown product"
      return redirect_to products_path
    end

    if session[:user_id] != @product.user_id
      redirect_to product_path(params[:id]), :alert => "Must be the merchant of this product to edit."
    end
  end

  def update
    if @product.update(product_params)
      flash[:success] = "Update successful!"
      redirect_to product_path(@product.id)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Cannot update product"
      flash.now[:messages] = @product.errors.messages
      render :edit, status: :bad_request
    end
  end

  def destroy
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      flash[:error] = "Unknown product"
      return redirect_to products_path
    end

    if session[:user_id] != @product.user_id
      return redirect_to product_path(params[:id]), :alert => "Must be the merchant of this product to edit."
    end

    if @product.destroy
      flash[:success] = "Succesfully deleted!"
      redirect_to products_path
    end
  end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :stock, :photo_url, :description, :user_id, category_ids: [], orderitem_ids: [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
  end
end
