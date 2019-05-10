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
        get product_path(product.id)
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

        flash[:messages].each do |key, value|
          if key == :name
            expect(value).must_equal ["can't be blank"]
          end

          if key == :stock
            expect(value).must_equal ["can't be blank", "is not a number"]
          end
        end

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
        product_to_update = products(:chair)
        new_name = "glitter bombz"
        test_input = {
          "product": {
            name: new_name,
            user_id: session[:user_id],
          },
        }

        expect {
          patch product_path(product_to_update), params: test_input
        }.wont_change("Product.count")

        expect(flash[:success]).must_equal "Update successful!"
        must_respond_with :redirect
        must_redirect_to product_path(product_to_update)
      end

      it "should respond with bad_request with invalid data" do
        product_to_update = products(:chair)
        test_input = {
          "product": {
            name: "",
            user_id: session[:user_id],
          },
        }

        expect {
          patch product_path(product_to_update), params: test_input
        }.wont_change("Product.count")

        flash.now[:messages].each do |key, value|
          if key == :name
            expect(value).must_equal ["can't be blank"]
          end
        end
      end
    end

    describe "destroy" do
      it "should destroy existing product" do
        existing_product = products(:honk)

        expect {
          delete product_path(existing_product.id)
        }.must_change "Product.count", -1

        must_respond_with :redirect
        must_redirect_to products_path
        expect(flash[:success]).must_equal "Succesfully deleted!"
      end

      it "should not let a seller who is not the owner of the product delete the product" do
        existing_product = products(:chair)

        expect {
          delete product_path(existing_product.id)
        }.wont_change "Product.count"

        expect(flash[:alert]).must_equal "Must be the merchant of this product to edit."
        must_respond_with :redirect
      end

      it "should respond with not found with product non-existing" do
        id = "bad_id"
        expect {
          delete product_path(id)
        }.wont_change("Product.count")

        expect(flash[:error]).must_equal "Unknown product"
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end
  end
end
