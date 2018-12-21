class WhenTag < Tag
  has_one :when_datum
  allow_nested_attributes_for :when_datum, allow_destroy: true
end
