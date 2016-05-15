class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create]

  private
    def check_captcha
      if verify_recaptcha
        true
      else
        self.resource = resource_class.new sign_up_params
        flash[:alert] = t('captcha.not_verified')
        respond_with_navigational(resource) { render :new }
      end
    end
end
