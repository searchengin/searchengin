class User < ApplicationRecord
  rolify

  before_create :set_user_handle
  after_action :assign_role, only:[:create]
  has_many :urls
  has_and_belongs_to_many :subcategory
  has_many :statuses
  has_many :likes
  has_many :dislikes
  acts_as_followable
  acts_as_follower

  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  validate :validate_username
  validates_presence_of   :avatar

  attr_writer :login
  mount_uploader :avatar, AvatarUploader

  enum user_type: [:regular, :domain]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook twitter],
         authentication_keys: [:login]

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

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def set_user_handle
    random_string = rand.to_s[2..11]
    self.handle = "#{self.username}#{random_string}"
  end

  def assign_role
      current_user.add_role :regular
  end

end


