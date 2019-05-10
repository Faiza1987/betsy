require "test_helper"

describe OrdersController do
  describe "merchants" do
    before do
      @user = users(:amyw)
      perform_login(@user)
    end

    describe "index action" do
      it "should display a list of order when the user is logged in" do
        get orders_path
        must_respond_with :success

        # delete all orderitems because this is the middle table connecting user, product and order
        orderitems(:trick).destroy
        orderitems(:treat).destroy

        get orders_path
        expect(flash[:message]).must_equal "You do not have any existing orders"
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end

    describe "show action" do
      it "should display all details of an individual order" do
        get order_path(orders(:one).id)
        must_respond_with :success
      end

      it "should create a new order or use existing order from cookies if given an invalid order id" do
        get order_path("INVALID ID")
        expect(cookies[:order_id]).wont_be_nil
        must_respond_with :ok
      end
    end
  end

  describe "guest users" do
    describe "index action" do
      it "should not let guest user view list of orders" do
        get orders_path
        expect(flash[:error]).must_equal "You must log in first."
      end
    end

    describe "update action" do
      let(:product) { products(:chair) }

      it "should change the order status from pending to paid, reduce product stock and clear all cookies" do
        # try to place an order
        input_quantity = 3
        test_input = {
          product_id: product.id,
          quantity: input_quantity,
        }

        post product_orderitems_path(product.id), params: test_input

        # find the order from cookies
        sample_order = Order.find_by(id: cookies[:order_id])

        current_stock = product.stock

        input_name = "Elmo"
        input_email = "elmo@friends.com"

        test_input = {
          "order": {
            name: input_name,
            email: input_email,
          },
        }

        expect {
          patch order_path(sample_order), params: test_input
        }.wont_change "Order.count"

        product.reload
        sample_order.reload

        order_item = Orderitem.find_by(id: sample_order.orderitem_ids.first)
        remaining_stock = current_stock - order_item.quantity

        expect(product.stock).must_equal remaining_stock
        expect(sample_order.status).must_equal "Paid"
        expect(flash[:result_text]).must_equal "Order was placed successully"
        expect(cookies[:order_id]).must_equal ""

        must_respond_with :redirect
        must_redirect_to order_path(sample_order.id)
      end
    end
  end
end
