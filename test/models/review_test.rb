require "test_helper"

describe Review do
  let(:review) { reviews(:one) }

  describe "validations" do
    it "must be valid" do
      review.rating.class.must_equal Integer
      assert review.valid?.must_equal true
    end

    it "must be invalid if rating is blank" do
      review.rating = nil
      review.valid?.must_equal false
    end

    it "must be invalid if rating is less than 1" do
      review.rating = 0
      review.valid?.must_equal false
    end

    it "must be invalid if rating is greater than 5" do
      review.rating = 6
      review.valid?.must_equal false
    end

    it "must be valid if description is nil" do
      review.description = nil
      review.valid?.must_equal true
    end
  end

  describe "relations" do
    it "must have a Product" do
      review.must_respond_to :product
      review.product.must_be_kind_of Product
      review.product.must_equal products(:chair)
      review.product_id.must_equal products(:chair).id
      review.product.name.must_equal "some brown chair"
    end
  end
end
