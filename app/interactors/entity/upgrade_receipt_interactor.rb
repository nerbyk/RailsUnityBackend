class Entity::UpgradeReceiptInteractor
  include TransactionalInteractor

  delegate :receipt, :receipt_static, to: :context

  before do
    context.fail!(message: "This receipt can't be upgraded yet") unless receipt.completed?
  end

  def call
    if receipt.entity.farm.spend_item(receipt_upgrade_level.cost)
      receipt.level_up!(receipt_upgrade_level.time)
    else
      context.fail!(message: "Not enough resources")
    end
  end

  private def receipt_upgrade_level = receipt_static.levels[receipt.level]
end
