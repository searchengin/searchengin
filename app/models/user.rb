class User < ApplicationRecord
  has_many :urls
  has_and_belongs_to_many :subcategory
  has_many :likes
  has_many :dislikes
  acts_as_followable
  acts_as_follower

  enum user_type: [:normal, :domain]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook twitter]

  extend FriendlyId
  friendly_id :email, use: [:slugged, :finders]
  scope :by_non_domain, -> { where(user_type: 0)}

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.avatar = auth.info.image
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

end


