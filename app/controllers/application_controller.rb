class ApplicationController < ActionController::Base
    #before_action :require_profile, :except=>[:new, :create]

    before_action :authenticate_user!
    before_action :download_avatar

    before_action :configure_permitted_parameters, if: :devise_controller?

    def download_avatar
      if user_signed_in?
        avatar = current_user.avatar.download
      end
    end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :about, :age, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :about, :age, :avatar])
  end

    private

    def require_profile
        if user_signed_in?
            if current_user.profile == nil
            redirect_to new_user_profile_path(current_user)
            end
        end
    end
end
