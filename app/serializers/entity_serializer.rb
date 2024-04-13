class EntitySerializer < ActiveModel::Serializer
  attributes :guid, :name, :location, :receipts

  def location
    {
      x: (object.location.x1.to_i..object.location.x2.to_i).to_a,
      y: (object.location.y1.to_i..object.location.y2.to_i).to_a
    }
  end

  def receipts
    object.entity_receipts || []
  end
end
