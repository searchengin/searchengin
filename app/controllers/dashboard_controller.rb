class DashboardController < ApplicationController
  # before_action :authenticate_user!

  def index
    @urls = Url.all.order("created_at DESC")
  end

  def get_url_object
    @url = Url.find(params[:id])
  end

  def get_domain
    domain = Domain.where("domain LIKE (?)", "#{params[:id]}%")

    if domain.present?
      domain_name = domain.first.domain
    else
      url = Url.find(params[:id])
      domain = Domain.create(domain: url.domain)
      domain_name = domain.domain
    end
    @urls = Url.where(domain: domain_name)
  end

  def search
  end

  def like
    url = Url.find(params[:url])
    user = url.user_id

    url.likes.each do |like|
      if like.user_id == current_user.id
        like.delete
      end
    end

    @like = Like.create(user_id: user, url_id: params[:url])

    url.dislikes.each do |dislike|
      if dislike.user_id == current_user.id
        dislike.delete
      end
    end
  end

  def dislike
    url = Url.find(params[:url])
    user = url.user_id

    url.dislikes.each do |dislike|
      if dislike.user_id = current_user.id
        dislike.delete
      end
    end

    Dislike.create(user_id: user, url_id: params[:url])

  end

end
