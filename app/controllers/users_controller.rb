class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_followable, only: [:follow_user, :unfollow_user]

  def index
    users = User.by_non_domain
    @users = current_user ? users.where.not(id: current_user.id) : users
  end

  def profile
  end

  def follow_user
    current_user.follow(@user)
  end

  def unfollow_user
    current_user.stop_following(@user)
  end

  private

  def set_followable
    @user = User.find(params[:id])
  end

end
