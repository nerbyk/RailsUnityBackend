class ReceiptsCompletionJob
  include Sidekiq::Worker

  def perform(*args)
    EntityReceipt.transaction { pending_receipts.update_all(status: :completed) }
  end

  private def pending_receipts
    EntityReceipt.where("status = ? AND completed_at <= ?", EntityReceipt.statuses[:pending], Time.current)
  end
end
