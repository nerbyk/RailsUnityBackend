class Entity < ApplicationRecord
  belongs_to :user
  belongs_to :farm
  has_many :entity_receipts, dependent: :destroy

  validate :location_overlap

  scope :overlaps, ->(farm_id, id, location) do
    where(farm_id: farm_id).where.not(id: id).where("location && ?", location.to_s)
  end

  GEO_FACTORY = RGeo::Geographic.simple_mercator_factory
  GARBAGE_ENTITIES_NAMES = %w[tree stone rock]
  
  def self.default_entities_file = File.read(Rails.root.join('app', 'assets', 'default_entity_map.json'))
  def self.initial_entities      = JSON.parse(default_entities_file, symbolize_names: true)
  def self.geo_factory           = GEO_FACTORY

  def self.generate_location(x_coords, y_coords)
    points = x_coords.zip(y_coords).map { |x, y| geo_factory.point(x, y) }

    geo_factory.multi_point(points)
  end

  def location=(value)
    if value in { x: Array[Integer, *] => x, y: Array[Integer, *] => y}
      super(Entity.generate_location(x, y))
    else
      super
    end
  end

  def location_overlap
    return unless Entity.overlaps(farm_id, id, self.location).exists?
      
    errors.add(:location, "overlaps with another entity")
  end
end
