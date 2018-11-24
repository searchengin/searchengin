class Url < ApplicationRecord
  belongs_to :user
  has_many :alias_tag
end
