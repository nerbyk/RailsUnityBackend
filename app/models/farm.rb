class Farm < ApplicationRecord
  belongs_to :user
  has_many :entities, dependent: :destroy
  has_many :entity_locations, dependent: :destroy
  has_many :items, dependent: :destroy

  after_create :create_default_entities_tile_map
  after_create :create_default_items

  def create_default_entities_tile_map
    farm_id = id

    default_entities_attrs = default_entities.map { |it| { name: it[:type], farm_id:, user_id: } }
    inserted_entity_ids = entities.insert_all(default_entities_attrs).then { |returning| returning.rows.flatten }

    map_tiles_to_insert = []
    default_entities.each_with_index do |default_entity, index|
      entity_id = inserted_entity_ids[index]

      default_entity[:x].each_with_index do |x, inner_index|
        y = default_entity[:y][inner_index]

        map_tiles_to_insert << { farm_id: , entity_id:, x: , y: }
      end
    end

    EntityLocation.insert_all(map_tiles_to_insert)
  end

  def create_default_items
    default_items_attrs = default_items.map { |it| { name: it[:name], amount: it[:amount], farm_id: id, user_id: user_id } }
    items.insert_all(default_items_attrs)
  end

  private 
  
  def default_entities
    @_default_entities ||= Entity.initial_entities
  end

  def default_items
    @_default_items ||= Item.initial_items
  end
end
