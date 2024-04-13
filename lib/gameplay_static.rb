module GameplayStatic
  STATICS_JSON = Rails.root.join("app/assets/gameplay_static.json")

  class Level < Struct.new(:cost)
    Cost = Data.define(:item_name, :amount)

    def initialize(cost)
      super(cost: Cost[**cost])
    end
  end

  def self.entities_statics
    JSON.parse(STATICS_JSON.read, symbolize_names: true).dig(:entities)
  end

  def self.receipts_statics
    JSON.parse(STATICS_JSON.read, symbolize_names: true).dig(:receipts)
  end

  module_function

  def self.entities
    @_entities ||= entities_statics.each_with_object({}) do |(name, data), hash|
      type = data.fetch(:type).to_sym
      levels = data.fetch(:levels).map do |it|
        receipts = it.dig(:receipts).map { |it| GameplayStatic.receipts[it.to_s.to_sym] } if it.key?(:receipts)
        cost = Level::Cost[**it.fetch(:cost)]

        Entity::BaseEntity::ELevel.new(receipts:, cost:)
      end

      hash[name] = Entity.build(type:, levels:)
    end
  end

  def self.receipts
    @_receipts ||= receipts_statics.each_with_object({}) do |(id, data), hash|
      item_name = data.fetch(:item_name)
      levels = data.fetch(:levels).map { |it| Level.new(**it.fetch(:cost)) }

      hash[id] = Receipt.new(item_name:, levels:)
    end
  end
end
