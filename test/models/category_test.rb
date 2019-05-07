require "test_helper"

describe Category do
  let(:category) { categories(:nsfw) }

  it "must be valid" do
    value(category).must_be :valid?
  end

  describe "relationships" do
    it "must respond to products" do
      expect(category).must_respond_to :products
    end
  end
end

