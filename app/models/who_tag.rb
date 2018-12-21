class WhoTag < Tag
  has_one :who_datum
  accepts_nested_attributes_for :who_datum, allow_destroy: true
end
