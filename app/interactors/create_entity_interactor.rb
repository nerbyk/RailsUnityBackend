class CreateEntityInteractor
  include TransactionalInteractor

  delegate :farm, :entity_params, :static_entity, to: :context

  before do
    if static_entity = GameplayStatic.entities[entity_params[:name].to_sym]
      context.fail!(message: "This entity type is not available for purchase") unless static_entity.respond_to?(:purchase_cost)
      context.static_entity = static_entity
    else
      context.fail!(message: "Unknown entity name")
    end
  end

  def call
    if farm.spend_item(static_entity.purchase_cost)
      farm.entities.create!(entity_params).tap { |entity| context.entity = entity }
    else
      context.fail!(message: "Not enough resources")
    end
  end
end
