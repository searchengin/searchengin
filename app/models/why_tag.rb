class WhyTag < Tag
  has_one :why_datum
  accepts_nested_attributes_fo :why_datum, allow_Destroy: true
end
