require "test_helper"

describe OrderitemsController do
  describe "index" do
    it "should get index" do
      get orderitems_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "should be OK to show an existing, valid order item" do
      valid_orderitem_id = orderitems(:trick).id

      get orderitem_path(valid_orderitem_id)

      must_respond_with :success
    end

    it "should give a flash notice instead of showing a non-existant, invalid order item" do
      order_item = orderitems(:treat)
      invalid_orderitem_id = order_item.id
      order_item.destroy

      # Act
      get orderitem_path(invalid_orderitem_id)

      # Assert
      must_respond_with :redirect
      expect(flash[:error]).must_equal "Unknown order item"
    end
  end

  describe "create" do
    it "will save a new order item and redirect if given valid inputs" do
      input_quantity = 3
      test_input = {
        "orderitem": {
          quantity: input_quantity,
          product_id: products(:honk).id,
          order_id: orders(:one).id,
        },
      }

      expect {
        post product_orderitems_path(products(:honk).id), params: test_input
      }.must_change "Orderitem.count", 1

      new_orderitem = Orderitem.find_by(quantity: input_quantity, product_id: products(:chair).id)

      expect(new_orderitem).wont_be_nil
      expect(new_orderitem.quantity).must_equal input_quantity
      expect(new_orderitem.product_id).must_equal products(:honk).id
      expect(new_orderitem.order_id).must_equal orders(:one).id

      must_respond_with :redirect
    end

    it "will give a 400 error with invalid params" do
      input_quantity = ""
      test_input = {
        "orderitem": {
          quantity: input_quantity,
          order_id: orders(:one).id,
          product_id: products(:chair).id,
        },
      }

      expect {
        post orderitems_path, params: test_input
      }.wont_change "Orderitem.count"

      expect(flash[:quantity]).must_equal ["can't be blank"]
      must_respond_with :bad_request
    end
  end

  describe "update" do
    it "will update an existing order item" do
      starter_input = {
        quantity: 3,
        order_id: orders(:one).id,
        product_id: products(:chair).id,
      }

      orderitem_to_update = Orderitem.create(starter_input)

      input_quantity = 9
      input_order_id = orders(:one).id
      input_product_id = products(:chair).id
      test_input = {
        "orderitem": {
          quantity: input_quantity,
          order_id: input_order_id,
          product_id: input_product_id,
        },
      }

      expect {
        patch orderitem_path(orderitem_to_update.id), params: test_input
      }.wont_change "Orderitem.count"

      must_respond_with :redirect
      orderitem_to_update.reload
      expect(orderitem_to_update.quantity).must_equal test_input[:orderitem][:quantity]
      expect(orderitem_to_update.order_id).must_equal test_input[:orderitem][:order_id]
      expect(orderitem_to_update.product_id).must_equal test_input[:orderitem][:product_id]
    end

    it "will return a bad_request (400) when asked to update with invalid data" do
      starter_input = {
        quantity: 3,
        order_id: orders(:one).id,
        product_id: products(:chair).id,
      }

      orderitem_to_update = Orderitem.create(starter_input)

      input_quantity = "" # Invalid Quantity
      input_order = orders(:one).id
      input_product = products(:chair).id
      test_input = {
        "orderitem": {
          quantity: input_quantity,
          order_id: input_order,
          product_id: input_product,
        },
      }

      expect {
        patch orderitem_path(orderitem_to_update.id), params: test_input
      }.wont_change "Orderitem.count"

      must_respond_with :bad_request
      orderitem_to_update.reload
      expect(orderitem_to_update.quantity).must_equal starter_input[:quantity]
      expect(orderitem_to_update.order_id).must_equal starter_input[:order_id]
      expect(orderitem_to_update.product_id).must_equal starter_input[:product_id]
    end

    # edge case: it should render a 404 if the order item was not found
  end

  describe "destroy" do
    it "returns a 404 if the order item is not found" do
      invalid_id = "NOT A VALID ID"

      expect {
        delete orderitem_path(id: invalid_id)
      }.wont_change "Orderitem.count"

      must_respond_with :not_found
    end

    it "can delete an order item" do
      new_order_item = Orderitem.create(quantity: 3, order_id: orders(:one).id, product_id: products(:chair).id)

      expect {
        delete orderitem_path(new_order_item.id)
      }.must_change "Orderitem.count", -1

      must_respond_with :redirect
      must_redirect_to order_path
    end
  end
end
