class ApplicationController < ActionController::Base

    #before_action :authenticate_user!

    #skip_before_action :authenticate_user!, :only => [:privacy]

    before_action :configure_permitted_parameters, if: :devise_controller?


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :about, :age, :avatar, :slug])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :about, :age, :avatar])
  end

end
