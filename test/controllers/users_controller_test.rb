require "test_helper"

describe UsersController do
  describe "login" do
    it "can log in an existing user" do
      # Arrange
      user_count = User.count

      # Act
      user = perform_login
      
      # Assert
      expect(user_count).must_equal User.count
      expect(session[:user_id]).must_equal user.id
      expect(flash[:status]).must_equal :success
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
end
