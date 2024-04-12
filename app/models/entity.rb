class Entity < ApplicationRecord
  belongs_to :user
  belongs_to :farm
  has_many :entity_receipts, dependent: :destroy

  validate :location_overlap

  scope :overlaps, ->(farm_id, id, location) do
    box_type = "'#{location.values.join(',')}'::box"

    where(farm_id: farm_id).where.not(id: id).where("location && #{box_type}")
  end

  GARBAGE_ENTITIES_NAMES = %w[tree stone rock]
  
  def self.default_entities_file = File.read(Rails.root.join('app', 'assets', 'default_entity_map.json'))
  def self.initial_entities      = JSON.parse(default_entities_file, symbolize_names: true)

  def self.generate_location(x_coords, y_coords)
    top = [x_coords.first, y_coords.first]
    bottom = [x_coords.last, y_coords.last]

    [top, bottom]
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
