class ScreenshotWorker
  include Sidekiq::Worker
  require 'webshot'

  # def perform(url_id)
  #   begin
  #   # Do something
  #   url = Url.find_by(id: url_id)
  #   link = url.url.split('://')
  #   domain_list = link.second.split('.').first
  #   puts "Capture screenshot by sidekiq >>>>>"
  #   # encoded_url = Base64.urlsafe_encode64(url)
  #   ws = Webshot::Screenshot.instance
  #   screenshot = ws.capture url.url, "#{domain_list}.png"
  #   thumb = MiniMagick::Image.open(screenshot.path)
  #   # img = thumb.write "#{domain_list}.png"

  #   url.update(screenshot: thumb)
  #   File.delete "#{domain_list[0]}.png"
  #   rescue Exception
  #   end
  # end

  # def perform(url_id, domain_list)
  #   puts "Capture screenshot by sidekiq >>>>>"
  #   Url.screenshot_capture url_id, domain_list
  # end
end
