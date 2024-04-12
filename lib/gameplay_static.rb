class GameplayStatic
  STATICS_JSON = Rails.root.join('app', 'assets', 'gameplay_static.json')  

  Cost = Data.define(:item_name, :amount)
  Level = Struct.new(:cost, :receipts, :action) do
    def initialize(cost:, **)
      super(cost: Cost[**cost], **)
    end
  end

  class GameObject < Data
    def self.define(*args)
      args <<= :levels

      super
    end

    def initialize(levels:, **)
      levels = levels.map { Level.new(**_1) }

      super(levels:, **)
    end
  end

  Entity  = GameObject.define(:type) do
    def initialize(type:, **)
      super(type: type.to_sym, **)
    end
  end
  
  Receipt = GameObject.define(:item)

  def self.entities_statics
    JSON.parse(File.read(STATICS_JSON), symbolize_names: true).dig(:entities)
  end

  def self.entities
    @_entities ||= entities_statics.each_with_object({}) do |(type, data), hash|
      data[:levels] ||= []

      hash[type] = Entity.new(**data)
    end
  end
end
