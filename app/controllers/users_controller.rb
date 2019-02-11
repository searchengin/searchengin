class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_followable, only: [:follow_user, :unfollow_user]
  before_action :post_params , only: [:post_status]

  def index
    users = User.by_non_domain
    @users = current_user ? users.where.not(id: current_user.id) : users
  end

  def profile
    @status = current_user.statuses.new
  end

  def follow_user
    current_user.follow(@user)
  end

  def unfollow_user
    current_user.stop_following(@user)
  end

  def post_status
    if current_user.statuses.create(post_params)
      redirect_to profile_users_path, notice: 'Status has been posted'
    else
      redirect_to root_url, notice: 'Status cannot be saved'
    end
  end

  private

  def set_followable
    @user = User.find(params[:id])
  end

  def post_params
    params.require(:status).permit(:post)
  end

end
