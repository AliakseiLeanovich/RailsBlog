class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @profiles = Profile.all
    respond_to do |format|
      format.html
      format.json { render json: @profiles.map{|profile| {:lat => profile.lat, :lng =>  profile.lng} } }
    end
  end

  def show
    respond_with(@profile)
  end

  def new
    @profile = Profile.new
    respond_with(@profile)
  end

  def edit
  end

  def create
    @profile = Profile.new(profile_params)

    if verify_recaptcha(model: @profile) && @profile.save
      respond_with(@profile)
    else
      render 'new'
    end
  end

  def update
    if verify_recaptcha(model: @profile) && @profile.update(profile_params)
      respond_with(@profile)
    else
      render 'edit'
    end
  end

  def destroy
    @profile.destroy
    respond_with(@profile)
  end

  private
    def set_profile
      @profile = Profile.find(params[:id])
    end

    def profile_params
      params.require(:profile).permit(:name, :description, :lat, :lng, :user_id)
    end
end
