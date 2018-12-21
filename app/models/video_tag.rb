class VideoTag < Tag
  has_one :video_datum
  allow_nested_attributes_for :video_datum, allow_destroy: true
end
