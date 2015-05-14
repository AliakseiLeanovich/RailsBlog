class RolesController < ApplicationController
  before_filter :check_permissions
  respond_to :html

  def index
    @roles = Role.all
    respond_with(@roles)
  end

  def show
    @role = Role.find(params[:id])
    respond_with(@role)
  end

  def new
    @role = Role.new
    respond_with(@role)
  end

  def edit
    @role = Role.find(params[:id])
  end

  def create
    @role = Role.new(role_params)
    @role.save
    respond_with(@role)
  end

  def update
    @role = Role.find(params[:id])
    @role.update(role_params)
    respond_with(@role)
  end

  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    respond_with(@role)
  end

  private
    def check_permissions
      if current_user == nil || !current_user.admin?
        redirect_to root_path, alert: t('role.no_permission')
      end
    end

    def role_params
      params.require(:role).permit(:title, :description, :create_ability, :read_ability, :update_ability, :delete_ability, user_ids: [])
    end
end
