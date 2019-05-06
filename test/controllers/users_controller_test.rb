require "test_helper"

describe UsersController do

  describe "index" do
    it "should get index" do
      # Arrange - Act 
      get users_path

      # Assert
      must_respond_with :success
    end
  end
  
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

    it "can log in a new user" do
      # Arrange
      new_user = User.new(provider: "github", username: "leaf", uid: 999, email: "leaf@email.com")

      expect {
        # Act
        perform_login(new_user)

        # Assert
      }.must_change "User.count", 1

      # Act
      user = User.find_by(uid: new_user.uid, provider: new_user.provider)
      
      # Assert
      expect(session[:user_id]).must_equal user.id
      expect(new_user.username).must_equal user.username
      expect(flash[:status]).must_equal :success
    end

    it "will respond with a redirect if a user is coming from somewhere other than github" do

      invalid_user = User.find_by(provider: "facebook")

      expect {
        perform_login(invalid_user)
      }.wont_change "User.count", 1

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "redirects to the login route if given invalid user data" do
      invalid_user = User.new(provider: "githib", username: "", uid: 50, email: "")

      expect{
        perform_login(invalid_user)
      }.wont_change "User.count", 1

      must_respond_with :redirect
      must_redirect_to root_path
    end

  end

  describe "current" do
    it "responds with redirect if no user is logged in" do
      # Arrange - Act
      get current_user_path

      # Assert
      must_respond_with :redirect
    end

    it "responds with success if user is logged in" do
      # Arrange
      logged_in_user = perform_login

      # Act
      get current_user_path
      
      # Assert
      must_respond_with :success
    end
  end

  describe "destroy" do
    it "will let a user logout" do
      current_user = users(:faiza)
      delete logout_path
      
      must_respond_with :redirect
    end
  end
end
