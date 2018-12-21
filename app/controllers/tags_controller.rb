class TagsController < ApplicationController

  def new

  end

  def create
    url = Url.find(params[:url])
    tags = url.tags.first.create(tag_params)


  end


  private

  def tag_params

    case
      when params.has_key?(:who_tag)
        params.require(:who_tag).permit(:name,
          who_datum_attributes: [:account, :website_url, :description]
        )
      when params.has_key?(:why_tag)
        params.require(:why_tag).permit()

      when params.has_key?(:what_tag)
        params.require(:what_tag).permit()

      when params.has_key?(:when_tag)
        params.require(:when_tag).permit()

      when params.has_key?(:where_tag)
        params.require(:where_tag).permit()

      else
        params.require(:video_tag).permit()
      end
    end

end
