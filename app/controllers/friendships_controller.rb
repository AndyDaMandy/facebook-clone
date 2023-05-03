# frozen_string_literal: true

# Friendships, belong to users
class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  def new; end

  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      flash[:notice] = 'Added friend.'
    else
      flash[:error] = 'Unable to add friend.'
    end
    redirect_to root_url
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = 'Removed friendship.'
    redirect_to current_user
  end
end
