class Entity::CreateReceiptInteractor
  include TransactionalInteractor

  delegate :entity, :create_params, to: :context

  before { set_receipt_schema }

  def call
    entity.farm.spend_item!(**receipt_initial_level.cost.to_h)
    entity.receipts.create!(
      **create_params,
      completed_at: (Time.current + receipt_initial_level.time)
    ).tap { |receipt| context.receipt = receipt }
  end

  private

  def receipt_initial_level = context.receipt_schema.levels.first

  def set_receipt_schema
    context.receipt_schema = entity.schema.levels.first.receipts[create_params[:name].to_sym]
  end
end
