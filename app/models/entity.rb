class Entity < ApplicationRecord
  belongs_to :user
  belongs_to :farm

  has_many :entity_receipts, dependent: :destroy

  before_validation { self.user ||= farm&.user }

  validate :validate_location_movability, if: :location_changed?, on: :update
  validate :validate_location_overlap, if: :location_changed?
  validate :validate_level_up, if: :level_changed?

  scope :overlaps, ->(farm_id, self_id, location) do
    raw_box = "'#{location.values.join(",")}'::box"

    where(farm_id: farm_id).where.not(id: self_id).where("location && #{raw_box}")
  end

  alias_method :receipts, :entity_receipts

  def self.default_entities_file = Rails.root.join("app/assets/default_entity_map.json").read

  def self.initial_entities = JSON.parse(default_entities_file, symbolize_names: true)

  def self.generate_location(x_coords, y_coords)
    top = [x_coords.first, y_coords.first]
    bottom = [x_coords.last, y_coords.last]

    [top, bottom]
  end

  def self.schema_for(name)
    GameplayStatic.entities[name.to_sym]
  end

  def schema = self.class.schema_for(name)

  def validate_location_movability
    return unless schema.garbage?

    errors.add(:location, "garbage entity can't be moved")
  end

  def validate_location_overlap
    return unless self.class.overlaps(farm_id, id, location).exists?

    errors.add(:location, "overlaps with another entity")
  end

  def validate_level_up
    return if level <= schema.levels.count

    errors.add(:level, "max level reached")
  end

  def location=(value)
    if value in { x: Array[Integer, *] => x, y: Array[Integer, *] => y}
      super(self.class.generate_location(x, y))
    else
      super
    end
  end
end
