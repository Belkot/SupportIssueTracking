class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: [:create, :index]

  respond_to :html

  def index
    @users = User.all
    respond_with(@user)
  end

  def create
    # admins only
    @user = User.new(user_params)
    flash[:notice] = "New user #{@user.username} created." if @user.save
    redirect_to users_path
  end

  private

    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :admin)
    end
end