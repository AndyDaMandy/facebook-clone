# frozen_string_literal: true

# Post controller
class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[new edit self_posts friend_posts create update destroy]

  # GET /posts or /posts.json
  def index
    # loads posts that are visible, posts that belong to friends that are visible, and the current users's posts.
    # It also orders them by created at and paginates them
    if user_signed_in?
      @posts = Post.where(visibility: [nil, 'post_visible'])
                   .or(Post.where(user_id: current_user.friends.ids, visibility: [nil, 'post_visible', 'friends_only'])
                   .and(Post.where(user_id: current_user.inverse_friends.ids, visibility: [nil, 'post_visible', 'friends_only'])))
                   .or(Post.where(user_id: current_user.id))
                   .order('created_at DESC').page(params[:page])
    else
      @posts = Post.where(visibility: [nil, 'post_visible'])
                   .order('created_at DESC').page(params[:page])
    end
  end

  def self_posts
    @user = current_user
    @posts = @user.posts.order('created_at DESC').page(params[:page])
  end

  def friend_posts
    @posts = Post.where(user_id: current_user.friends.ids, visibility: 'friends_only')
                 .and(Post.where(user_id: current_user.inverse_friends.ids, visibility: 'friends_only'))
                 .order('created_at DESC').page(params[:page])
  end

  def user_posts
    @user = User.friendly.find_by_friendly_id(params[:user_id])
    if user_signed_in?
      if @user == current_user.friends.find_by(id: @user.id) && @user == current_user.inverse_friends.find_by(id: @user.id)
        @posts = Post.where(visibility: [nil, 'post_visible', 'friends_only'])
                     .and(Post.where(user_id: @user.id))
                     .order('created_at DESC').page(params[:page])
      else
        @posts = Post.where(visibility: [nil, 'post_visible'])
                     .and(Post.where(user_id: @user.id))
                     .order('created_at DESC').page(params[:page])
      end
    else
      @posts = Post.where(visibility: [nil, 'post_visible'])
                   .and(Post.where(user_id: @user.id))
                   .order('created_at DESC').page(params[:page])
    end

  end

  # GET /posts/1 or /posts/1.json
  def show; end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.new(post_params)
    @post.images.attach(params[:images])

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params.reject { |k| k['images'] })
        if post_params[:images].present?
          post_params[:images].each do |image|
            @post.images.attach(image)
          end
        end
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_images
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge
    redirect_back(fallback_location: posts_path)
  end


  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:user_id, :content, :visibility, images: [])
  end
end
