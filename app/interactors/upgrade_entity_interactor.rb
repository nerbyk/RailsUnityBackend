class UpgradeEntityInteractor
  include TransactionalInteractor

  delegate :entity, :entity_schema, to: :context

  before do
    context.fail!(message: "This entity can't be upgraded") unless entity_schema.respond_to?(:upgrade_cost)
  end

  def call
    entity.farm.spend_item!(upgrade_cost)
    entity.level_up!
  end

  private def upgrade_cost = entity_schema.upgrade_cost(to: entity.level + 1)
end
