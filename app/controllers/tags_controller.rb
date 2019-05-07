class TagsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i( tag_verification )

  def new

  end

  def create
    @url = Url.find(params[:url])
    if params[:who_tag]
      @data = @url.who_tags.build(tag_params)
    elsif params[:where_tag]
      @data = @url.where_tags.build(tag_params)
    elsif params[:what_tag]
      @data = @url.what_tags.build(tag_params)
    elsif params[:when_tag]
      @data = @url.when_tags.build(tag_params)
    elsif params[:why_tag]
      @data = @url.why_tags.build(tag_params)
    elsif params[:photo_tag]
      @data = @url.photo_tags.build(tag_params)
    elsif params[:video_tag]
      @data = @url.video_tags.build(tag_params)
    end
    if current_user.has_role?('regular') || current_user.has_role?('superadmin') && @data.is_bot == false
      @data.points = 3
    elsif @data.is_bot == true
      @data.points = 1
    end
    @data.save!(validate: false)
    #tags = url.tags.first.create(tag_params)
    flash[:success] = "Tag successfully added."
    redirect_to root_url
  end

  def verify_tags
    @urls = Url.all.order("created_at DESC").paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def tag_verification
    tag = Tag.find params[:id]
    if current_user.has_role?('superadmin') && tag.verified == false
      points = tag.points + 5
      tag.update_attributes!(verified_user_id: current_user.id, verified: true,points: points)
      url_points = tag.url.points + 5
      tag.url.update_attributes!(points: url_points)
      flash[:success] = "Tag verified"
    else
      current_user.has_role?('superadmin') && tag.verified == true
      points = tag.points - 5
      tag.update_attributes!(verified: false, points: points)
      url_points = tag.url.points - 5
      tag.url.update_attributes!(points: url_points)
      flash[:success] = "Tag Unverified"
    end
    if params[:page] == "profile"
      redirect_to profile_path(current_user.handle)
    elsif params[:page] == "show"
      redirect_to urls_show_path(tag.url.slug)
    else
      redirect_to root_url
    end

  end

  private

  def tag_params
    case
      when params.has_key?(:who_tag)
        params.require(:who_tag).permit(:name,:user_id,
          who_datum_attributes: [:account, :website_url, :description]
        )
      when params.has_key?(:where_tag)
        params.require(:where_tag).permit(:user_id,
          where_datum_attributes: [:location , :description]
          )
      when params.has_key?(:what_tag)
        params.require(:what_tag).permit(:user_id,
          what_datum_attributes: [:category, :item_name, :description, :website_url]
          )
      when params.has_key?(:when_tag)
        params.require(:when_tag).permit(:user_id,
          when_datum_attributes: [:date, :time, :description]
          )
      when params.has_key?(:why_tag)
        params.require(:why_tag).permit(:user_id,
          why_datum_attributes: [:subject, :subcategory, :title, :description, :link]
          )
      when params.has_key?(:photo_tag)
        params.require(:photo_tag).permit(:user_id,
          photo_datum_attributes: [:photo_url]
          )
      else
        params.require(:video_tag).permit(:user_id,
          video_datum_attributes: [:video_url, :category, :html_code, :description]
          )
      end
    end

end
