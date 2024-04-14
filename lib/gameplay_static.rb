class GameplayStatic
  STATICS_JSON = Rails.root.join("app/assets/gameplay_static.json")

  UndefinedStaticError = Class.new(StandardError)

  Cost = Data.define(:item_name, :amount)

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

    @_entities = statics.each_with_object(static_hash_for(:entity)) do |(name, data), hash|
      type = data.fetch(:type).to_sym
      levels = entity_level_build_options(data.fetch(:levels))

      hash[name] = Entity.build(type:, levels:)
    end

    @_entities.freeze
  end

  def self.preload_receipts(statics)
    require_relative "gameplay_static/receipt"

    @_receipts = statics.each_with_object(static_hash_for(:receipt)) do |(id, data), hash|
      item_name = data.fetch(:item_name)
      levels = receipt_level_build_options(data.fetch(:levels))

      hash[id] = Receipt.new(item_name:, levels:)
    end

    @_receipts.freeze
  end

  def self.entity_level_build_options(levels)
    levels.map do |level|
      cost = Cost[**level.fetch(:cost)]
      rcps = level[:receipts]&.map do |id| 
        id_sym = id.to_s.to_sym

        [id_sym, receipts[id_sym]] 
      end.to_h

      Entity::BaseEntity::Level.new(cost:, receipts: rcps)
    end
  end

  def self.receipt_level_build_options(levels)
    levels.map do |level|
      cost = Cost[**level.fetch(:cost)]
      time = level.fetch(:time)

      Receipt::Level.new(cost:, time:)
    end
  end

  def self.static_hash_for(name)
    Hash.new { |hash, key| raise UndefinedStaticError, "Undefined #{name} name: #{key}" }
  end
end

GameplayStatic.load
