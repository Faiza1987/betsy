require "test_helper"

describe ProductsController do
  let(:bad_product_id) { Product.first.destroy.id }

  describe "index" do
    it "can get index" do
      get products_path
      must_respond_with :success
    end
  end

  describe "new" do
    it "can get new page" do
      get new_product_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a product" do
      @user = User.all.sample
      perform_login(@user)

      new_product = {
        product: {
          name: "Great Prank",
          category: "SFW",
          quantity: 3,
          price: 0.99,
          user: @user,
        },
      }

      test_product = Product.new(new_product[:product])

      expect {
        post products_path, params: new_product
      }.must_change("Product.count", +1)

      must_redirect_to product_path(Product.last)
    end

    it "does not create a new product w/ invalid data" do
      @user = User.all.sample
      perform_login(@user)

      new_product = {
        product: {
          name: "",
          category: "SFW",
          quantity: 3,
          price: 0.99,
          user: @user,
        },
      }

      test_product = Product.new(new_product[:product])

      expect {
        post products_path, params: new_product
      }.wont_change("Product.count")

      must_respond_with :bad_request
    end
  end
end
