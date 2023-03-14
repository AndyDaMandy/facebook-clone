class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, :only => [:new, :edit, :create, :update, :destroy]

  # GET /posts or /posts.json
  def index
      @posts = Post.where(visibility: [nil, "post_visible"]).or(Post.where(:user_id => current_user.friends, visibility: [nil, "post_visible", "friends_only"])).or(Post.where(:user_id => current_user.id)).order("created_at DESC").page(params[:page]) 
    #@posts = Post.filter_by_user_id(params[:user_id])
  end
  def self_posts
    @user = current_user
    @posts = @user.posts.order("created_at DESC").page(params[:page])
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.new(post_params)
    @post.images.attach(params[:images])

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
=begin
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
=end
respond_to do |format|
  if @post.update(post_params.reject { |k| k["images"] })
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
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_images
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge
    redirect_back(fallback_location: posts_path)
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:user_id, :content, :visibility, images: [])
    end
end
