class CreateEntityInteractor
  include TransactionalInteractor

  delegate :farm, :entity_params, :entity_schema, to: :context

  before do
    unless entity_schema.respond_to?(:purchase_cost)
      context.fail!(message: "This entity type is not available for purchase")
    end
  end

  def call
    farm.spend_item!(entity_schema.purchase_cost)
    farm.entities.create!(entity_params).tap do |entity|
      context.entity = entity
    end
  end
end
