class ProductsController < ApplicationController
  private

  def product_params
    return params.require(:product, :name).permit(:category, :price, :stock, :user_id)
  end
end
