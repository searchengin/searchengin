class WhyTag < Tag
  has_one :why_datum
  belongs_to :url
  accepts_nested_attributes_for :why_datum, allow_destroy: true
end
