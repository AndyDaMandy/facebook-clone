class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  def index
    @users = User.all
    #.page params[:page]
    if params[:search_by_first_name] && params[:search_by_first_name] != ""
      @users = @users.where("first_name like ?", 
      "%# {params[:search_by_first_name]}%")
    end
    if params[:search_by_last_name] && params[:search_by_last_name] != ""
      @users = @users.where("last_name like ?", 
      "%# {params[:search_by_last_name]}%")
    end
    #@users = User.search(params[:search]) unless params[:search].blank?
    #.order(:last_name).page params[:page]
    #avatar = @user.avatar.download
    #@user = User.filter_by_first_name(params[:first_name])
    #@user = User.filter_by_last_name(params[:last_name])
  end

    def show
        #@user = User.friendly.find(params[:id])
        #finds user by slug thus preventing you from finding users easily
        @user = User.find_by!(slug: params[:id])
        #avatar = @user.avatar.download
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
      def accept_friend
      @friend = User.friendly.find_by(params[:inverse_friend_id])
        #@inverse_friends
      #@friend.inverse_friendships.friend
      end

      def search
        @key = "%#{params[:search]}%"
        @users = User.where("lower(first_name) LIKE ? or lower(last_name) LIKE ?", @key.downcase, @key.downcase)
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
        params.require(:user).permit(:user_id, :first_name, :last_name, :age, :about, :avatar, :slug, :search, :status, :inverse_friend_id)
    end
end
