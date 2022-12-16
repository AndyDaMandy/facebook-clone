class ProfilesController < ApplicationController
    def show
    end
    def new
        @profile = Profile.new
    end
    def create
        @profile = current_user.build_profile(profile_params)
        respond_to do |format|
            if @profile.save
              format.html { redirect_to profile_url(@profile), notice: "Profile was successfully created." }
              format.json { render :show, status: :created, location: @profile }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @profile.errors, status: :unprocessable_entity }
            end
          end
    end
    
    def edit
        
    end

    private
    def profile_params
        params.require(:profile).permit(:user_id, :first_name, :last_name, :age, :likes, :dislikes, :about)
    end

end
