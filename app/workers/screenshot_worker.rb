class ScreenshotWorker
  include Sidekiq::Worker

  # def perform(url)
  #   # Do something
  #   url = Url.find_by(url)
  #   puts "Capture screenshot by sidekiq >>>>>"
  #   # encoded_url = Base64.urlsafe_encode64(url)
  #   binding.pry
  #   ws = Webshot::Screenshot.instance
  #   screenshot = ws.capture url.url, "#{domain_list[0]}.png"
  #   thumb = MiniMagick::Image.open(screenshot.path)
  #   thumb.write "#{domain_list[0]}.png"

  #   url.update(screenshot: thumb)
  #   File.delete "#{domain_list[0]}.png"
  # end

  def perform(url_id, domain_list)
    puts "Capture screenshot by sidekiq >>>>>"
    Url.screenshot_capture url_id, domain_list
  end


end
