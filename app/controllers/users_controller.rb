class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: [:index, :create, :destroy]

  respond_to :html

  def index
    @users = User.all
    respond_with(@user)
  end

  def create
    @user = User.new(user_params)
    flash[:notice] = "New user #{@user.username} created." if @user.save
    redirect_to users_path
  end

  def destroy
    @user = User.find(params[:id])
    @user.enable = false
    flash[:notice] = "User #{@user.username} disabled." if @user.save
    redirect_to users_path
  end

  private

    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :admin)
    end
end