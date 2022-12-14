class ProfilesController < ApplicationController
    def show
    end
    def new
        @profile = Profile.new
    end
    def create
        @profile = current_user.build_profile(profile_params)
    end

    private
    def profile_params
        params.require(:profile).permit(:user_id, :first_name, :last_name, :age, :likes, :dislikes, :about)
      end

end
