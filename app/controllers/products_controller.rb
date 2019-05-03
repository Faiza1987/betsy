class ProductsController < ApplicationController
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

  private

  def product_params
    return params.require(:product, :name).permit(:category, :price, :stock, :user_id)
  end
end
