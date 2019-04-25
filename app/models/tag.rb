class Tag < ApplicationRecord
  belongs_to :user
  belongs_to :url
  belongs_to :verified_user, foreign_key: 'verified_user_id', class_name: 'User', optional: true
  belongs_to :rejected_user, foreign_key: 'rejected_user_id', class_name: 'User', optional: true
  belongs_to :rejected_cancel_user, foreign_key: 'rejected_cancel_user_id', class_name: 'User', optional: true
  has_many :like, dependent: :destroy
  has_many :dislike, dependent: :destroy
  # has_many :what_datum, foreign_key: :what_tag_id
  # has_many :who_datum, foreign_key: :who_tag_id
  # has_many :when_datum, foreign_key: :when_tag_id
  # has_many :why_datum, foreign_key: :why_tag_id
  # has_many :where_datum, foreign_key: :where_tag_id
  # has_many :video_datum, foreign_key: :video_tag_id
  # has_many :photo_datum, foreign_key: :photo_tag_id
end
