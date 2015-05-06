class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @users = User.all
    respond_with(@user)
  end

  def new
    @user = User.new
    respond_with(@user)
  end

  def show
    respond_with(@user)
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    flash[:notice] = "New user #{@user.username} created." if @user.save
    redirect_to users_path
  end

  def update
    @user.update(user_params)
    respond_with(@user)
  end

  def destroy
    @user.enable = false
    flash[:notice] = "User #{@user.username} disabled." if @user.save
    redirect_to users_path
  end

  private

    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :admin, :enable)
    end

   def set_user
    @user = User.find(params[:id])
   end
end