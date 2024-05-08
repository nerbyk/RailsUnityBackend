class Entity::UpgradeReceiptInteractor
  include TransactionalInteractor

  delegate :receipt, :entity, to: :context

  before { set_receipt_schema }

  def call
    receipt.entity.farm.spend_item!(**receipt_upgrade_level.cost.to_h)
    receipt.update!(
      level: receipt.level + 1,
      status: receipt.class.statuses[:pending],
      completed_at: Time.current + receipt_upgrade_level.time
    )
  end

  private

  def receipt_upgrade_level = context.receipt_schema.levels[receipt.level]

  def set_receipt_schema
    context.receipt_schema = entity.schema
      .levels[entity.level - 1]
      .receipts[receipt.name.to_sym]
  end
end
