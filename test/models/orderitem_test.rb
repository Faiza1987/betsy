require "test_helper"

describe Orderitem do
  let(:orderitem) { orderitems(:trick) }

  it "must be valid" do
    value(orderitem).must_be :valid?
  end
end
