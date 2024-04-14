class EntityReceiptsSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :level, :completed_at
end
