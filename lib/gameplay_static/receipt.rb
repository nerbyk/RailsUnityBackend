class GameplayStatic
  class Receipt < Data.define(:item_name, :levels)
    Level = Data.define(:cost, :time)

    def upgrade_cost(to:)
      levels[to - 1].cost
    end
  end
end
