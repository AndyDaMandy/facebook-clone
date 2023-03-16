class LikesController < ApplicationController

    #https://medium.com/full-taxx/how-to-add-likes-to-posts-in-rails-e81430101bc2
    before_action :authenticate_user!, only: => [:create, :destroy]
    before_action :find_post  
    before_action :find_like, only: => [:destroy]
    def create
        if already_liked?
          flash[:notice] = "You can't like more than once"
        else
          @post.likes.create(user_id: current_user.id)
        end
        redirect_to post_path(@post)
      end
      def destroy
        if !(already_liked?)
          flash[:notice] = "Cannot unlike"
        else
          @like.destroy
        end
        redirect_to post_path(@post)
      end
      def find_like
        @like = @post.likes.find(params[:id])
     end
    private  
    def find_post
        @post = Post.find(params[:post_id])
    end
    def already_liked?
        Like.where(user_id: current_user.id, post_id:
        params[:post_id]).exists?
      end
end
