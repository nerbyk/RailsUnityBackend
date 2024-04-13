module GameplayStatic
  class Entity
    def self.build(type:, levels:)
      case type
      when :garbage
        GarbageEntity.new(type: type, levels: levels)
      when :factory
        FactoryEntity.new(type: type, levels: levels)
      else 
        raise ArgumentError, "Unknown entity type: #{type}"
      end
    end

    class BaseEntity < Data.define(:type, :levels)
      ELevel = Struct.new(*Level.members, :receipts)

      def garbage?
        type == :garbage
      end

      def factory?
        type == :factory
      end
    end
  
    class GarbageEntity < BaseEntity
      def destroy_cost
        levels.first.cost
      end
    end
  
    class FactoryEntity < BaseEntity
      def purchase_cost
        levels.first.cost
      end
    end
  end
end