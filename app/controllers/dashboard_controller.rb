class DashboardController < ApplicationController
  # before_action :authenticate_user!

  def index
    @urls = Url.all
  end

end
