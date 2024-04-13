class Item < ApplicationRecord
  belongs_to :user
  belongs_to :farm

  before_validation { self.user ||= farm&.user }

  def self.initial_items
    JSON.parse(Rails.root.join("app/assets/default_items_map.json").read, symbolize_names: true)
  end
end
