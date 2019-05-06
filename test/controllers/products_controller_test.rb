require "test_helper"

describe ProductsController do
  let(:bad_product_id) { Product.first.destroy.id }

  describe "Guest User" do
    describe "index" do
      it "can get index" do
        get products_path
        must_respond_with :success
      end
    end

    describe "new" do
      it "should flash error if unauthorized user tries to create a new product" do
        get new_product_path
        must_respond_with :redirect
        must_redirect_to root_path
        expect(flash[:error]).must_equal "You must log in first."
      end
    end

    describe "show" do
      it "should respond with success for show existing product" do
        product = products(:chair)
        get products_path(product.id)
        must_respond_with :success
      end

      it "should respond with error for show non-existing product" do
        id = "bad_id"
        get product_path(id)
        expect(flash[:error]).must_equal "Unknown product"
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end

    describe "edit" do
      it "should respond with error when unauthorized user tries to edit existing product" do
        get edit_product_path(Product.first)
        must_respond_with :redirect
        must_redirect_to root_path
        expect(flash[:error]).must_equal "You must log in first."
      end
    end
  end

  describe "Logged In User" do
    before do
      perform_login
    end

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
        test_input = {
          "product": {
            name: "newproduct",
            stock: 3,
            price: 35,
            user_id: session[:user_id],
          },
        }

        expect {
          post products_path, params: test_input
        }.must_change "Product.count", 1

        new_product = Product.find_by(name: "newproduct")

        must_respond_with :redirect
        must_redirect_to product_path(new_product.id)
      end

      it "does not create product with missing data" do
        test_input = {
          "product": {
            name: "",
            quantity: 3,
            stock: "",
            price: 3400,
            user_id: session[:user_id],
          },
        }

        expect {
          post products_path, params: test_input
        }.wont_change("Product.count")

        expect(flash[:name]).must_equal ["can't be blank"]
        expect(flash[:stock]).must_equal ["can't be blank", "is not a number"]
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
        expect(flash[:error]).must_equal "Unknown product"
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end

    describe "edit" do
      it "should respond with found for edit existing product" do
        get edit_product_path(products(:honk))
        must_respond_with :success
      end

      it "should respond with redirect and error for edit non-existing product" do
        id = "bad_id"
        get edit_product_path(id)
        must_respond_with :redirect
        expect(flash[:error]).must_equal "Unknown product"
      end

      it "should respond with a flash message when a seller tries to edit a product that is not theirs" do
        get edit_product_path(products(:chair))
        expect(flash[:alert]).must_equal "Must be the merchant of this product to edit."
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
end
