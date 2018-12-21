class WhereTag < Tag
  has_one :where_datum
  allow_nested_attributes_for :where_datum, allow_destroy: true
end
