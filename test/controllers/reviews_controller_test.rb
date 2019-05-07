require "test_helper"

describe ReviewsController do
  let(:product) { products(:chair) }

  describe "new" do
    it "can create a new review" do
      get new_product_review_path(product.id)
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a new review for product given valid data" do
      proc {
        post product_reviews_path(product.id), params: {
                                                 review: {
                                                   rating: 1,
                                                   description: "Worst chair ever.",
                                                 },
                                               }
      }.must_change "Review.count", +1

      must_respond_with :redirect
      must_redirect_to product_path(product.id)
    end

    it "does not create a new review for product given invalid data" do
      proc {
        post product_reviews_path(product.id), params: {
                                                 review: {
                                                   rating: "one",
                                                   description: "Worst chair ever.",
                                                 },
                                               }
      }.wont_change "Review.count"
    end
  end
end
