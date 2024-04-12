class EntitySerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :receipts

  def location
    l = { x: [], y: [] }

    self.object.location.coordinates.each do |x, y|
      l[:x] << x.to_i
      l[:y] << y.to_i
    end

    l
  end

  def receipts
    self.object.entity_receipts || []
  end
end
