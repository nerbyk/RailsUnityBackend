class Item < ApplicationRecord
  belongs_to :user
  belongs_to :farm

  before_validation { self.user ||= farm&.user }

  def self.initial_items
    JSON.parse(File.read(Rails.root.join('app', 'assets', 'default_items_map.json')), symbolize_names: true)
  end
end
