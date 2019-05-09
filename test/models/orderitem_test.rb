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

  describe "custom quantity invalid method" do
    it "will return false if quantity is less than stock" do
      expect(orderitems(:trick).is_quantity_invalid?).must_equal false
    end

    it "will return false if quantity is equal to stock" do
      expect(orderitems(:halloween).is_quantity_invalid?).must_equal false
    end

    it "will return true if quantity larger than stock" do
      expect(orderitems(:pumpkin).is_quantity_invalid?).must_equal true
    end
  end

  describe "custom calculate cost method" do
    it "will return total cost for quantity larger than one" do
      expect(orderitems(:treat).calculate_cost).must_equal 5000
    end

    it "will return total cost for quantity one" do
      expect(orderitems(:candy).calculate_cost).must_equal 2500
    end
  end

  describe "custom add quantity method" do
    it "will add additional quantity to existing quantity (1)" do
      expect(orderitems(:trick).add_quantity(24)).must_equal 25
    end

    it "will add additional quantity to existing quantity (more than 1)" do
      expect(orderitems(:treat).add_quantity(23)).must_equal 25
    end
  end
end
