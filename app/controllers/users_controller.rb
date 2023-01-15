class UsersController < ApplicationController

    def show
        @user = User.find(params[:id])
    end

    def edit
        @user = current_user
        #@profile = current_user.profile
          
      end
  
      def update
        @user = current_user
        respond_to do |format|
          if @user.update(profile_params)
            format.html { redirect_to user_url(@user), notice: "PRofile was successfully updated." }
            format.json { render :show, status: :ok, location: @user }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      end

      

      def apply_omniauth(auth)
        update_attributes(
          provider: auth.provider,
          uid: auth.uid
        )
      end

      def has_facebook_linked?
        self.provider.present? && self.uid.present?
      end

    private
      def profile_params
        params.require(:user).permit(:user_id, :first_name, :last_name, :age, :about)
    end
end
