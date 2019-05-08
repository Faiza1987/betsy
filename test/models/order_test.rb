require "test_helper"

describe Order do
  let(:order) { orders(:one) }
  let(:order_2) { orders(:two) }
  let(:order_3) { orders(:three) }

  #   describe "validations" do
  #     it "must be valid" do
  #       order.valid?.must_equal true
  #     end

  #     it "must be invalid when billing info is blank and status is nil" do
  #       order_2.valid?.must_equal false
  #     end

  #     it "must be valid when billing info is filled and status is paid or complete" do
  #       order.valid?.must_equal true
  #     end

  #     it "must be invalid when billing info is blank and status is paid or complete" do
  #       order_3.valid?.must_equal false
  #     end
  #   end

  describe "calculate_total" do
    it "returns total cost of an order" do
      order.calculate_total.must_equal 1000
    end

    it "returns 0 when there are no orderitems" do
      order_3.calculate_total.must_equal 0
    end
  end
end
