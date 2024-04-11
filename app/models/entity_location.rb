class EntityLocation < ApplicationRecord
  belongs_to :entity
  belongs_to :farm
end
