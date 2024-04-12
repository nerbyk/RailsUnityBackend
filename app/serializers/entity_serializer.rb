class EntitySerializer < ActiveModel::Serializer
  attributes :guid, :name, :location, :receipts

  def location
    {
      x: (self.object.location.x1.to_i..self.object.location.x2.to_i).to_a,
      y: (self.object.location.y1.to_i..self.object.location.y2.to_i).to_a
    }
  end

  def receipts
    self.object.entity_receipts || []
  end
end
