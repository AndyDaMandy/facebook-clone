class ApplicationController < ActionController::Base
    before_action :require_profile, :except=>[:new, :create]

    private

    def require_profile
        if user_signed_in?
            if current_user.profile == nil
            redirect_to new_user_profile_path(current_user)
            end
        end
    end
end
