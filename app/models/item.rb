class Item < ApplicationRecord
  belongs_to :user
  belongs_to :farm

  before_validation { self.user ||= farm&.user }

  validates :amount, numericality: {greater_than_or_equal_to: 0, message: "Not enough resources"}

  def self.initial_items
    JSON.parse(Rails.root.join("app/assets/default_items_map.json").read, symbolize_names: true)
  end
end
