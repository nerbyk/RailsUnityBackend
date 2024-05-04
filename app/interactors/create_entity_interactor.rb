class CreateEntityInteractor
  include TransactionalInteractor

  delegate :farm, :entity_params, :entity_static, to: :context

  before do
    unless entity_static.respond_to?(:purchase_cost)
      context.fail!(message: "This entity type is not available for purchase")
    end
  end

  def call
    farm.spend_item!(entity_static.purchase_cost)
    farm.entities.create!(entity_params).tap do |entity|
      context.entity = entity
    end
  end
end
