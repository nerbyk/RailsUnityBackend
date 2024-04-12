class Farm < ApplicationRecord
  belongs_to :user
  has_many :entities, dependent: :delete_all
  has_many :items, dependent: :destroy

  after_create :create_default_entities_tile_map
  after_create :create_default_items

  def create_default_entities_tile_map
    default_entities_attrs = default_entities.map do |it| 
      { name: it[:type], farm_id: id, user_id: user_id, location: Entity.generate_location(it[:x], it[:y]) } 
    end

    Entity.insert_all(default_entities_attrs)
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
