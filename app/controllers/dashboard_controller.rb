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
    search = params[:search]
    # if params[:search]
    # binding.pry
    #   @results = WhatDatum.where("description = ? OR website_url = ? OR item_name ILIKE (?)",params[:search], params[:search], params[:search])
    #   what_ids = @results.pluck(:what_tag_id)
    #  what_tags = Tag.find
    # end

    #Tag.joins(:what_tags).where("who_datum.description = ? OR who_datum.website_url  ILIKE (?)",params[:search], params[:search])
    #@tag = Tag.joins(:what_datum, :who_datum).where("what_data.description = ? OR what_data.website_url  ILIKE (?)", params[:search], params[:search]).where("account = ? OR description  ILIKE (?)",params[:search], params[:search])
    #redirect_to dashboard_result_path
  #end
  @urls_data = {}
  @tag  = Tag.joins(:where_datum).where("location = ? OR description ILIKE (?)",params[:search], params[:search])
  # @tag = Tag.joins(:what_datum).where("what_data.description = ? OR what_data.website_url  ILIKE (?)", params[:search], params[:search]) || Tag.joins(:who_datum).where("account = ? OR description  ILIKE (?)",params[:search], params[:search]) || Tag.joins(:when_datum).where("description ILIKE (?)", params[:search]) || Tag.joins(:where_datum).where("location = ? OR description ILIKE (?)",params[:search], params[:search]) || Tag.joins(:why_datum).where("title = ? OR description ILIKE (?)", params[:search],params[:search])

  if @tag.first
    tag_id = @tag.first.id
    first_tag = Tag.find(tag_id)
    @urls_data[first_tag.url] = [first_tag]
  end

  url = Url.all.where("domain = ? AND subdomain = ? AND like ILIKE (?)", params[:search],params[:search], params[:search])

  end

  def like
    #like = Like.where(user_id: current_user.id, url_id: params[:url])
    likes = Like.where(url_id: params[:url])
    if likes.count > 0
      likes.each do |like|
        if like.user_id == current_user.id
          like.delete
        end
      end
    else
      like = Like.create(user_id: current_user.id, url_id: params[:url])
    end
    @like_count =  Like.where(url_id: params[:url]).count
  end

  def dislike
    dislikes = Dislike.where(url_id: params[:url])
    if dislikes.count > 0
      dislikes.each do |dislike|
        if dislike.user_id == current_user.id
          dislike.delete
        end
      end
    else
     dislike = Dislike.create(user_id: current_user.id, url_id: params[:url])
    end
      @dislike_count = Dislike.where(url_id: params[:url]).count
  end

end
