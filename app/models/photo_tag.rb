class PhotoTag < Tag
  belongs_to :url
  has_one :photo_datum
  accepts_nested_attributes_for :photo_datum, allow_destroy: true
end
