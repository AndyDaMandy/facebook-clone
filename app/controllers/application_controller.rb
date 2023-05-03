# frozen_string_literal: true

# Application controller
class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name about age avatar slug])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name about age avatar])
  end

end
