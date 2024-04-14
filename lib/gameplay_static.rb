class GameplayStatic
  STATICS_JSON = Rails.root.join("app/assets/gameplay_static.json")

  UndefinedStaticError = Class.new(StandardError)

  class Level < Struct.new(:cost)
    Cost = Data.define(:item_name, :amount)

    def initialize(cost)
      super(cost: Cost[**cost])
    end
  end

  def self.entities = @_entities

  def self.receipts = @_receipts

  def self.load
    statics = JSON.parse(STATICS_JSON.read, symbolize_names: true)

    preload_receipts(statics.fetch(:receipts))
    preload_entities(statics.fetch(:entities))

    freeze
  end

  private_class_method

  def self.preload_entities(statics)
    require_relative "gameplay_static/entity"

    @_entities = statics.each_with_object(static_hash) do |(name, data), hash|
      type = data.fetch(:type).to_sym
      levels = data.fetch(:levels).map do |it|
        rcpts = it.dig(:receipts).map { |it| receipts[it.to_s.to_sym] } if it.key?(:receipts)
        cost = Level::Cost[**it.fetch(:cost)]

        Entity::BaseEntity::ELevel.new(receipts: rcpts, cost:)
      end

      hash[name] = Entity.build(type:, levels:)
    end

    @_entities.freeze
  end

  def self.preload_receipts(statics)
    require_relative "gameplay_static/receipt"

    @_receipts = statics.each_with_object(static_hash) do |(id, data), hash|
      item_name = data.fetch(:item_name)
      levels = data.fetch(:levels).map { |it| Level.new(**it.fetch(:cost)) }

      hash[id] = Receipt.new(item_name:, levels:)
    end

    @_receipts.freeze
  end

  def self.static_hash
    Hash.new { |hash, key| raise UndefinedStaticError, "Undefined static: #{key}" }
  end
end

GameplayStatic.load
