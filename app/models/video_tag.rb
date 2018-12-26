class VideoTag < Tag
  has_one :video_datum
  belongs_to :url
  accepts_nested_attributes_for :video_datum, allow_destroy: true
end
