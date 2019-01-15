module DashboardHelper

  def url_concate url
  #url[0..30].gsub(/\s\w+\s*$/, '...') + url[-20, 20]
    if url.length > 30
      url = url.truncate(20) + url[-15,15]
    else
      url
    end
  end
end
