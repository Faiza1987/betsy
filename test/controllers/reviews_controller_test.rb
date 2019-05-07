require "test_helper"

describe ReviewsController do
  let(:product) { products(:chair) }

  describe "new" do
    it "succeeds" do
      get new_product_review_path(product.id)
      must_respond_with :success
    end
  end
end
