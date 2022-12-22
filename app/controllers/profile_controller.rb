class ProfileController < ApplicationController
    before_action :authenticate_user!, :only => [:new, :edit, :create, :update, :destroy]

    def index
        @user = current_user
        @profile = @user.profile
    end
    def show
      @profile = Profile.find(params[:id])
    end
    def new
      @user = current_user
      if @user.profile == nil
      @profile = current_user.build_profile
      end
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
      @user = current_user
      @profile = current_user.profile
        
    end

    def update
      respond_to do |format|
        if @profile.update(post_params)
          format.html { redirect_to post_url(@profile), notice: "Post was successfully updated." }
          format.json { render :show, status: :ok, location: @profile }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @profile.errors, status: :unprocessable_entity }
        end
      end
    end

    private
    def profile_params
        params.require(:profile).permit(:user_id, :first_name, :last_name, :age, :likes, :dislikes, :about)
    end
end
