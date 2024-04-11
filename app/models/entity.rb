class Entity < ApplicationRecord
  belongs_to :user
  belongs_to :farm
  has_many :entity_locations, dependent: :destroy
  has_many :entity_receipts, dependent: :destroy

  GARBAGE_ENTITIES_NAMES = %w[tree stone rock]

  def self.initial_entities
    JSON.parse(File.read(Rails.root.join('app', 'assets', 'default_entity_map.json')), symbolize_names: true)
  end
end
