class PhotoTag < Tag
  belongs_to :url
  has_one :photo_datum
end
