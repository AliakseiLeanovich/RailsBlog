class UsersController < ApplicationController

  before_filter :check_permissions, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user != @user
      @user.destroy
    else
      redirect_to users_path, alert: t('user.delete_own')
    end
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:email, :nickname, :location)
  end

  def check_permissions
    if current_user == nil || !current_user.admin?
      redirect_to users_path, alert: t('user.no_permission')
    end
  end
end