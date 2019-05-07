require "test_helper"

describe Orderitem do
  let(:orderitem) { orderitems(:trick) }

    it "must be valid" do
      value(orderitem).must_be :valid?
    end

    it "must be a valid order_item" do
      valid_orderitem = orderitem.valid?
      expect(valid_orderitem).must_equal true
    end

    describe "validations" do
      it "requires quantity" do
        orderitem.quantity = nil
        valid_orderitem = orderitem.valid?

        expect(valid_orderitem).must_equal false
        expect(orderitem.errors.messages).must_include :quantity
        expect(orderitem.errors.messages[:quantity]).must_include "can't be blank"
      end
    end

    describe "relationships" do
      it "must respond to product" do
        expect(orderitem).must_respond_to :product
      end

      it "must respond to order" do
        expect(orderitem).must_respond_to :order
      end
    end
end
