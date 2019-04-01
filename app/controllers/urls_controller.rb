class UrlsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def index
  end

  def new
    @url = Url.new
  end

  def create
    if params[:url][:url].present?
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
          # ScreenshotWorker.perform_async(@url.id)
          format.html { redirect_to root_url, notice: 'Url was successfully processed.' }
          # format.json { render :show, status: :created, url: @url }
        else
          format.html { render :new }
          format.json { render json: @url.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:Error] = "please enter a url"
    end
  end

  def show
    @url = Url.find_by(slug: params[:slug])
  end

  def tags
    @url = Url.find(params[:url])
    @type = params[:title]
  end

  # def show
  #   @url = Url.find(params[:id])
  #   @user = User.find_or_create_by(username: @url.domain)
  #   unless @url.domain.include? (".")
  #     @url.store_domain_info
  #   end
  # # hack for old or crashed urls and tags
  #   if @user == nil
  #     @user = User.find(username: 'roger')
  #   end
  #   @is_admin = false
  #   if signed_in?
  #     @request_user = current_user
  #     @is_admin = @request_user.admin
  #   else
  #     @request_user = nil
  #   end
  #   if @url[:title]
  #     @title = "| " + @url[:title]
  #     if @url.domain
  #       @title += " · " + @url.domain
  #     end
  #   end
  #   # call to scrapinghub
  #   if not @url.title or (not @url.screenshot_url and not @url.cover_data)
  #     system("curl -u 95064c54aa18481a8638143870f39e5d: https://app.scrapinghub.com/api/run.json -d project=143676 -d spider=searchengine -d url='#{@url.url}' -d mode=-1 -d depth=1")
  #   end
  #   # limit = 10
  #   # @tags = Tag.where(url_id: @url[:id]).reverse_order(:id).
  #   #     limit(limit).offset( ((params[:page] || 1).to_i - 1) * limit )
  #   @tags = Tag.where(url_id: @url[:id]).reverse_order

  # end

  def display_main_url
    @url = Url.find_by(slug: params[:id])
    if @url.present?
      redirect_to @url.url
    else
      flash[:Error] = "please enter a url"
    end
  end


  private
    def url_params
      params.require(:url).permit(:url)
    end

end
