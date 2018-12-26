class WhenTag < Tag
  has_one :when_datum
  belongs_to :url
  accepts_nested_attributes_for :when_datum, allow_destroy: true
end
