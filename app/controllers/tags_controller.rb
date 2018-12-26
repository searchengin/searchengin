class TagsController < ApplicationController

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
    @data.save(:validate => false)
    #tags = url.tags.first.create(tag_params)
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
      else
        params.require(:video_tag).permit(:user_id,
          video_datum_attributes: [:video_url, :category, :html_code, :description]
          )
      end
    end

end
