class WhatTag < Tag
  has_one :what_datum
  belongs_to :url
  accepts_nested_attributes_for :what_datum, allow_destroy: true
end
