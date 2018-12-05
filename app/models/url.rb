class Url < ApplicationRecord
  belongs_to :user
  has_many :alias_tag
  # has_many :images, as: :imageable, dependent: :destroy

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
    rescue Exception
    end
  end


end
