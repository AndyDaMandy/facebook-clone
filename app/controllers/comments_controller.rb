# frozen_string_literal: true

# Comments, belonging to users
class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to post_path(@post)
    else
      flash[:error] = 'Your comment can only be between 1 and 120 characters'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    # @comment = @post.comments.find(comment_params)
    # @post= Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_back fallback_location: root_path
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :user_id, :comment)
  end
end
