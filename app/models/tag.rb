class Tag < ApplicationRecord
  belongs_to :user
  belongs_to :url
  belongs_to :verified_user, foreign_key: 'verified_user_id', class_name: 'User'
  belongs_to :rejected_user, foreign_key: 'rejected_user_id', class_name: 'User'
  belongs_to :rejected_cancel_user, foreign_key: 'rejected_cancel_user_id', class_name: 'User'
  has_many :like
  has_many :dislike

end
