class EntitySerializer < ActiveModel::Serializer
  attributes :id, :name, :position, :receipts

  def position
    positions = self.object.entity_locations.pluck(:x, :y)

    { 
      x: positions.map(&:first), 
      y: positions.map(&:second) 
    }
  end

  def receipts
    self.object.entity_receipts || []
  end
end
