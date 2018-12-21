class DashboardController < ApplicationController
  # before_action :authenticate_user!

  def index
    @urls = Url.all.order("created_at DESC")
  end

  def get_url_object
    @url = Url.find(params[:id])
  end

  def search
  end

  def like
    url = Url.find(params[:url])
    user = url.user_id
    Like.create(user_id: user, url_id: params[:url])

    url.likes.each do |like|
      if like.user_id == current_user.id
        like.delete
      end
    end

    url.dislikes.each do |dislike|
      if dislike.user_id == current_user.id
        dislike.delete
      end
    end
  end

  def dislike
    url = Url.find(params[:url])
    user = url.user_id
    Dislike.create(user_id: user, url_id: params[:url])

    url.dislike.each do |dislike|
      if dislike.user_id = current_user.id
        dislike.delete
      end
    end

  end

end
