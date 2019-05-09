class ApplicationController < ActionController::Base
  before_action :find_user

  def require_login
    current_user = find_user

    if current_user.nil?
      flash[:error] = "You must log in first."

      redirect_to root_path
    end
  end

  private

  def find_user
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end
  end

end 
