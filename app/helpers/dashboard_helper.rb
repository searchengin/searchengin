module DashboardHelper

  def url_concate url
  #url[0..30].gsub(/\s\w+\s*$/, '...') + url[-20, 20]
    if url.length > 30
      url_data = url.split('/')
      url = url_data.third+"..."+url[url.length-10,url.length-1]
      #url = url.truncate(20) + url[-15,15]
    else
      url
    end
  end
end
