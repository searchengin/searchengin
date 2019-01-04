class Url < ApplicationRecord
  require 'webshot'

  belongs_to :user
  has_many :tags
  has_many :who_tags
  has_many :where_tags
  has_many :what_tags
  has_many :when_tags
  has_many :why_tags
  has_many :video_tags

  mount_uploader :screenshot, ImageUploader

  after_create :store_domain_info

  def store_domain_info
    begin

      protocol, url = self.url.split('://')
      url = url.split('/').first
      domain_list = url.split('.')
      if domain_list.length > 2
        subdomain = domain_list.first
        domain = domain_list[1, domain_list.length].join('.')
      else
        subdomain = ""
        domain = url
      end
      self.update(protocol: protocol)
      self.update(subdomain: subdomain)
      self.update(domain: domain)
      self.update_domain
      ws = Webshot::Screenshot.instance
      screenshot = ws.capture self.url, "#{domain_list[0]}.png"
      thumb = MiniMagick::Image.open(screenshot.path)
      thumb.write "#{domain_list[0]}.png"
      self.update(screenshot: thumb)
      File.delete "#{domain_list[0]}.png"
      # ScreenshotWorker.perform_async(self.id, domain_list[0])
    rescue Exception
    end
  end

  def domain_object
    if Domain.where(domain: self.domain).count == 0
      Domain.create(domain: self.domain)
    end
    Domain.find(domain: self.domain)
  end

  def update_domain
    self.domain_object.calculate_points
  end

  def domain_user
    user = User.find_by(username: self.domain)
    unless user
      user = User.new(username: self.domain, email: nil)
      user.save(validate: false)
    end
    unless Domain.where(domain: self.domain).count > 0
      self.update_domain
    end
    user
  end

  # def user
  #   user = User.where(id: self.user_id).first
  #   user = User.find_by(username: self.domain)
  #   unless user
  #     user = User.new(username: self.domain, email: nil)
  #     user.save
  #   end
  #   if Domain.where(domain: self.domain).count > 0
  #     user = User.find_by(username: self.domain)
  #     unless user
  #       user = User.new(username: self.domain, email: nil)
  #       user.save
  #     end
  #   else
  #     unless user
  #       self.update_domain
  #       user = User.find_by(username: self.domain)
  #       unless user
  #         user = User.new(username: self.domain, email: nil)
  #         user.save
  #       end
  #     end
  #   end
  #   user
  # end

  def likes
    Like.where(url_id: self.id)
  end

  def dislikes
    Dislike.where(url_id: self.id)
  end


  # def self.screenshot_capture(url_id, domain_list)
  #   url = Url.find_by(id: url_id)
  #   ws = Webshot::Screenshot.instance
  #   screenshot = ws.capture url.url, "#{domain_list}.png"
  #   thumb = MiniMagick::Image.open(screenshot.path)
  #   thumb.write "#{domain_list}.png"

  #   url.update(screenshot: thumb)
  #   File.delete "#{domain_list}.png"
  # end


end
