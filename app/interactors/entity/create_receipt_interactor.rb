class Entity::CreateReceiptInteractor
  include TransactionalInteractor

  delegate :entity, :entity_static, :receipt_name, to: :context
  delegate :receipt_static, to: :context

  before do
    context.receipt_static = entity_static.levels.first.receipts[receipt_name.to_sym]
  end

  def call
    entity.farm.spend_item!(receipt_initial_level.cost)
    entity.receipts.create!(
      name: receipt_name,
      completed_at: (Time.current + receipt_initial_level.time)
    ).tap { |receipt| context.receipt = receipt }
  end

  private def receipt_initial_level = receipt_static.levels.first
end
