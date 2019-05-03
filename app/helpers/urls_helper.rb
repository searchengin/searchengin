module UrlsHelper

  def limit_tags url
    #url.tags.where(verified: 'true').count == 3 ? url.tags.where(verified: 'true') : url.tags.order(created_at: 'DESC').limit(3)
    url.tags.order(created_at: 'DESC').limit(3)
  end
end
