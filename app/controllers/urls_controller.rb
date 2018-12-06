class UrlsController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  def new
    @url = Url.new
  end

  def create
    url_object = LinkThumbnailer.generate(params[:url][:url])
    @url = current_user.urls.new
    @url.title = url_object.title
    @url.url = url_object.url
    @url.description = url_object.description
    @url.favicon_url = url_object.favicon
    # @url.domain = Url.store_domain_info
    # @url.subdomain = Url.store_domain_info
    # @url.protocol = Url.store_domain_info
    # UrlWorker.perform_async(url_object)
    respond_to do |format|
      if @url.save
        format.html { redirect_to root_url, notice: 'Url was successfully processed.' }
        # format.json { render :show, status: :created, url: @url }
      else
        format.html { render :new }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @url = Url.find(params[:id])
  end

  private
    def url_params
      params.require(:url).permit(:url)
    end

end
