class UsersController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def index
    @user = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    user = User.find_by(uid: auth_hash[:uid], provider: "github")

    if user
      flash[:result_text] = "Successfully logged in as #{user.username}"
    else
      user = User.build_from_github(auth_hash)

      if user.save
        flash[:result_text] = "Logged in as new user #{user.name}"
      else
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:user_id] = user.id
    return redirect_to root_path
  end

  def current
    @user = User.find_by(id: session[:user_id])
    if @user.nil?
      flash[:error] = "You must log in first!"
      
      redirect_to root_path
    end

    def destroy 
      session[:user_id] = nil
      flash[:status] = :success
      flash[:result_text] = "Successfully logged out"

      redirect_to root_path
    end
  end



end # class end
