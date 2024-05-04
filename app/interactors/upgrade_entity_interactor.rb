class UpgradeEntityInteractor
  include TransactionalInteractor

  delegate :entity, :entity_static, to: :context

  before do
    context.fail!(message: "This entity can't be upgraded") unless entity_static.respond_to?(:upgrade_cost)
  end

  def call
    entity.farm.spend_item!(upgrade_cost)
    entity.level_up!
  end

  private def upgrade_cost = entity_static.upgrade_cost(to: entity.level + 1)
end
