class ApplicationController < ActionController::Base
  before_action :find_user

  def find_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def require_login
    current_user = find_user

    if current_user.nil?
      flash[:error] = "You must log in first."

      redirect_to root_path
    end
  end
end
