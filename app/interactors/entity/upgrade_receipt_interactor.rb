class Entity::UpgradeReceiptInteractor
  include TransactionalInteractor

  delegate :receipt, :receipt_schema, to: :context

  before do
    context.fail!(message: "This receipt can't be upgraded yet") unless receipt.completed?
  end

  def call
    receipt.entity.farm.spend_item!(receipt_upgrade_level.cost)
    receipt.level_up!(receipt_upgrade_level.time)
  end

  private def receipt_upgrade_level = receipt_schema.levels[receipt.level]
end
