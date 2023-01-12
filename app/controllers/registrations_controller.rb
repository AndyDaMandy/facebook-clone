class RegistrationsController < ApplicationController

    def after_sign_up_path_for(resource)
        user_edit_path(current_user)
      end
end
