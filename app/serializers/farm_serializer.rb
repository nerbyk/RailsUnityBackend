class FarmSerializer < ActiveModel::Serializer
  attributes :id, :active
  has_many :entities
  has_many :items
end
