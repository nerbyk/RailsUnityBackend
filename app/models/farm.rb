class Farm < ApplicationRecord
  belongs_to :user
  has_many :entities, dependent: :delete_all
  has_many :items, dependent: :destroy

  def self.create_initial_farm(user)
    Farm.create!(user:).tap(&:create_initial_game_state)
  end

  def create_initial_game_state
    entities.insert_all(default_entities)
    items.insert_all(default_items)
  end

  private

  def default_entities
    Entity.initial_entities.map do |it|
      {
        farm_id: id,
        user_id: user_id,
        name: it[:type],
        location: Entity.generate_location(it[:x], it[:y])
      }
    end
  end

  def default_items
    Item.initial_items.map do |it|
      {
        farm_id: id,
        user_id: user_id,
        name: it[:name],
        amount: it[:amount]
      }
    end
  end
end
