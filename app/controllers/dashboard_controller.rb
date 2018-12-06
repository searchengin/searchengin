class DashboardController < ApplicationController
  # before_action :authenticate_user!

  def index
    @urls = Url.all.order("created_at DESC")
  end

end
