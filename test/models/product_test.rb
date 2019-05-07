require "test_helper"

describe Product do
  let(:product) { products(:honk) }

  it "must be valid" do
    value(product).must_be :valid?
  end

  it "must have a valid product" do
    valid_product = product.valid?
    expect(valid_product).must_equal true
  end

  describe "validations" do
    it "requires a name" do
      product.name = ""
      valid_product = product.valid?

      expect(valid_product).must_equal false
      expect(product.errors.messages).must_include :name
      expect(product.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "requires a unique name" do
      product_with_duplicate_name = Product.new(name: product.name)

      expect(product_with_duplicate_name.save).must_equal false
      expect(product_with_duplicate_name.errors.messages).must_include :name
      expect(product_with_duplicate_name.errors.messages[:name]).must_equal ["has already been taken"]
    end

    it "requires a price" do
      product.price = ""
      product_with_price = product.valid?

      expect(product_with_price).must_equal false
      expect(product.errors.messages).must_include :price
      expect(product.errors.messages[:price]).must_include "can't be blank"
      expect(product.errors.messages[:price]).must_include "is not a number"
    end

    it "must have a price that is a number greater than 0" do
      product.price = -1
      product_with_price_at_zero = product.valid?

      expect(product_with_price_at_zero).must_equal false
      expect(product.errors.messages).must_include :price
      expect(product.errors.messages[:price]).must_include "must be greater than 0"
    end
    it "must have a quantity" do
      product.stock = ""
      product_not_in_stock = product.valid?

      expect(product_not_in_stock).must_equal false
      expect(product.errors.messages).must_include :stock
      expect(product.errors.messages[:stock]).must_include "can't be blank"
      expect(product.errors.messages[:stock]).must_include "is not a number"
    end
    it "must have a quantity that is greater than 0" do
      product.stock = -1
      product_with_no_stock = product.valid?

      expect(product_with_no_stock).must_equal false
      expect(product.errors.messages).must_include :stock
      expect(product.errors.messages[:stock]).must_include "must be greater than or equal to 0"
    end
  end

  describe "relationships" do
    it "must respond to user" do
      expect(product).must_respond_to :user
    end

    it "must respond to reviews" do
      expect(product).must_respond_to :reviews
    end

    it "must respond to categories" do
      expect(product).must_respond_to :categories
    end

    it "must respond to orderitems" do
      expect(product).must_respond_to :orderitems
    end

    it "must respond to orders" do
      expect(product).must_respond_to :orders
    end
  end

  describe "custom methods" do
    it "will get an average rating for products" do

    end
  end
end
