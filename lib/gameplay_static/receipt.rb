class GameplayStatic
  class Receipt < Data.define(:item_name, :levels)
    Level = Data.define(:cost, :time)
  end
end
