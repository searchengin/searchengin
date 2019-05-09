class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i( set_editor )
  before_action :authenticate_user!
  before_action :set_user, only: [:follow_user, :unfollow_user, :set_role]
  def index
    users = User.by_non_domain
    @users = current_user ? users.where.not(id: current_user.id) : users
  end

  def profile
    @user = User.find_by(handle: params[:id])
    unless @user
      domain = Domain.where("domain LIKE (?)", "#{params[:id]}%")
      if domain.present?
        domain_name = domain.first.domain
      else
        url = Url.find(params[:id])
        domain = Domain.create(domain: url.domain)
        domain_name = domain.domain
      end
      @urls = Url.where(domain: domain_name)
    else
      @status = @user.statuses.new
    end

  end

  def follow_user
    current_user.follow(@user)
  end

  def unfollow_user
    current_user.stop_following(@user)
  end

  def post_status
    if current_user.statuses.create(post_params)
      redirect_to profile_path(current_user.handle), notice: 'Status has been posted'
    else
      redirect_to root_url, notice: 'Status cannot be saved'
    end
  end

  def set_role
    @user.roles.destroy_all
    @user.add_role "#{Role.find(user_params[:roles]).name}"
    redirect_to users_path, notice: 'User role changed'
  end

  def set_editor
    user = User.find params[:id]
    if current_user.has_role?('superadmin') && user.editor == false
      user.update_attributes!(editor: true)
      flash[:success] = "Set Editor"
    elsif current_user.has_role?('superadmin') && user.editor == true
      user.update_attributes!(editor: false)
      flash[:success] = "Unset Editor"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def post_params
    params.require(:status).permit(:post)
  end


  def user_params
    params.require(:user).permit(:roles)
  end
end
