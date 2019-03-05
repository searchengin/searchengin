module UsersHelper

  def post_user_name user_status
    user_id = user_status.user_id
    username = User.find_by(id: user_id).try(:username)
  end
end
