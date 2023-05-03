# frozen_string_literal: true

# For omniauth and devise
class AuthenticationsController < ApplicationController
  def destroy
    current_user.update_attributes(provider: nil, uid: nil)
    redirect_to edit_user_registration_path, notice: 'Facebook Account Unlinked'
  end
end
