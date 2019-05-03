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

    it "does not create product with missing data" do
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

  describe "show" do
    it "should respond with success for show existing product" do
      product = products(:glitter_bomb)
      get products_path(product.id)
      must_respond_with :success
    end

    it "should respond with missing for show non-existing product" do
      id = bad_id
      get product_path(id)
      must_respond_with :missing
    end
  end

  describe "edit" do
    it "should respond with found for edit existing product" do
      get edit_product_path(Product.first)
      must_respond_with :found
    end

    it "should respond with not found for edit non-existing product" do
      id = bad_id
      get edit_product_path(id)
      must_respond_with :not_found
    end
  end

  describe "update" do
    it "should update product with valid data" do
      @user = User.all.sample
      perform_login(@user)

      @product = products(:glitter_bomb)
      updated_name = "glitter bombz"
      put product_path(@product.id),
          params: {
            product: {
              name: updated_name,
            },
          }
      @product.reload
      assert_equal updated_name, @product.name
    end

    it "should respond with bad_request with invalid data" do
      @user = User.all.sample
      perform_login(@user)

      @product = products(:glitter_bomb)
      updated_name = ""
      put product_path(@product.id),
          params: {
            product: {
              name: updated_name,
            },
          }
      must_respond_with :bad_request
    end
  end
end
