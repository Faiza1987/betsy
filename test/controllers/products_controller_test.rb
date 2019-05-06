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

      product_params = {
        name: "newproduct",
        stock: 3,
        price: 35,
        user: @user,
      }

      expect { Product.create(product_params) }.must_change "Product.count", 1
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

      test_product = Product.new

      expect {
        post products_path, params: new_product
      }.wont_change("Product.count")

      must_respond_with :bad_request
    end
  end

  describe "show" do
    it "should respond with success for show existing product" do
      product = products(:chair)
      get products_path(product.id)
      must_respond_with :success
    end

    it "should respond with missing for show non-existing product" do
      id = "bad_id"
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
      id = "bad_id"
      get edit_product_path(id)
      must_respond_with :not_found
    end
  end

  describe "update" do
    it "should update product with valid data" do
      @user = User.all.sample
      perform_login(@user)

      @product = products(:chair)
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

      @product = products(:chair)
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

  describe "destroy" do
    it "should destroy existing product" do
      user = users(:amyw)
      perform_login(user)

      session[:user_id] = user.id
      product = products(:chair)
      expect(product.user_id).must_equal user.id

      expect {
        delete product_path(product.id)
      }.must_change("Product.count", -1)

      must_respond_with :redirect
      must_redirect_to products_path
      expect(flash[:success]).must_equal "Succesfully deleted!"
    end

    it "should respond with not found with product non-existing" do
      id = "bad_id"
      expect {
        delete product_path(id)
      }.wont_change("Product.count")

      must_respond_with :not_found
    end
  end
end
