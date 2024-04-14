class CreateEntityInteractor
  include TransactionalInteractor

  delegate :farm, :entity_params, :entity_static, to: :context

  before do
    unless entity_static.respond_to?(:purchase_cost)
      context.fail!(message: "This entity type is not available for purchase")
    end
  end

  def call
    if farm.spend_item(entity_static.purchase_cost)
      farm.entities.create!(entity_params).tap { |entity| context.entity = entity }
    else
      context.fail!(message: "Not enough resources")
    end
  end
end
