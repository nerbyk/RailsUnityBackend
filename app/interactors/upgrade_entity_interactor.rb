class UpgradeEntityInteractor
  include TransactionalInteractor

  delegate :entity, to: :context

  before do
    context.new_level = entity.level + 1

    if !entity.schema.respond_to?(:upgrade_cost) || upgrade_cost.nil?
      context.fail!(message: "This entity can't be upgraded")
    end
  end

  def call
    entity.update!(level: context.new_level)
    entity.farm.spend_item!(**upgrade_cost.to_h)
  end

  private def upgrade_cost = entity.schema.upgrade_cost(to: context.new_level)
end
