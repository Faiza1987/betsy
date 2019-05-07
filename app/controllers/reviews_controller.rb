class ReviewsController < ApplicationController
  before_action :logged_in?

  def new
    @product = Product.find(params[:product_id])
    @review = Review.new(product: @product)
  end

  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.build(review_params)
    @review.product = @product

    if @product.user_id == session[:user_id]
      flash[:warning] = "Cannot review own product."
      redirect_to products_path
    elsif @review.save
      redirect_to @product
    else
      flash.now[:warning] = "Missing required field(s)."
      render :new
    end

    def destroy
      @review.destroy
      respond_to do |format|
        format.html { redirect_to products_path, notice: "Successfully deleted!" }
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:product_id, :rating, :description)
  end

  def logged_in?
    @reviewer = User.find_by(id: session[:user_id])
  end
end
