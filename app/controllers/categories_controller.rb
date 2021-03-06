class CategoriesController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def index
    @categories = Category.all.order(:name)
  end
  
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Category added!"
      redirect_to categories_path
    else
      flash.now[:error] = @category.errors
      render :new, status: :error
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, product_ids: [])
  end
end
