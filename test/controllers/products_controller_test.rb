require "test_helper"

describe ProductsController do
  let(:bad_product_id) { Product.first.destroy.id }

  describe "index" do
    it "should get index" do
      get products_path
      must_respond_with :success
    end
  end

  describe "new" do
    it "can get the new page" do
      get new_product_path
      must_respond_with :success
    end
  end
end
