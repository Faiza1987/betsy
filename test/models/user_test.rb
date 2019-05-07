require "test_helper"

describe User do
  let(:user) { users(:faiza) }

  it "must be valid" do
    value(user).must_be :valid?
  end

  it "must have a valid user" do
    user = users(:faiza)

    valid_user = user.valid?
    expect(valid_user).must_equal true
  end

  describe "validations" do
    it "requires a username" do 
      user.username = ""
      valid_user = user.valid?
      
      expect(valid_user).must_equal false
      expect(user.errors.messages).must_include :username
      expect(user.errors.messages[:username]).must_equal ["can't be blank"]
    end

    it "requires a unique name" do
      duplicate_user = User.new(username: user.username)

      expect(duplicate_user.save).must_equal false
      expect(duplicate_user.errors.messages).must_include :username
      expect(duplicate_user.errors.messages[:username]).must_equal ["has already been taken"]
    end

    it "requires an email address" do
      user.email = ""
      valid_user_with_email = user.valid?

      expect(valid_user_with_email).must_equal false
      expect(user.errors.messages).must_include :email
      expect(user.errors.messages[:email]).must_equal ["can't be blank"]
    end

    it "requires a unique email" do
      user_with_duplicate_email = User.new(email: user.email)

      expect(user_with_duplicate_email.save).must_equal false
      expect(user_with_duplicate_email.errors.messages).must_include :email
      expect(user_with_duplicate_email.errors.messages[:email]).must_equal ["has already been taken"]
    end
  end

  describe "relationships" do
    it "has many products" do
      expect(user).must_respond_to :products
    end
  end
end
