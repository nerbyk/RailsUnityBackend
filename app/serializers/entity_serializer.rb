class EntitySerializer < ActiveModel::Serializer
  attributes :guid, :name, :location, :receipts

  def location
    self.object.location.coordinates.each_with_object({ x: [], y: [] }) do |(x, y), loc|
      loc[:x] << x.to_i
      loc[:y] << y.to_i
    end
  end

  def receipts
    self.object.entity_receipts || []
  end
end
