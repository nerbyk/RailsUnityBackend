class CreateEntityInteractor
  include TransactionalInteractor

  delegate :farm, :entity_params, to: :context

  before do
    unless entity_schema.respond_to?(:purchase_cost)
      context.fail!(message: "This entity type is not available for purchase")
    end
  end

  def call
    farm.spend_item!(**entity_schema.purchase_cost.to_h)
    farm.entities.create!(entity_params).tap do |entity|
      context.entity = entity
    end
  end

  private def entity_schema = ::Entity.schema_for(entity_params[:name])
end
