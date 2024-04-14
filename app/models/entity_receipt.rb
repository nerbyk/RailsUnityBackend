class EntityReceipt < ApplicationRecord
  belongs_to :entity

  enum status: {pending: 0, completed: 1}

  def level_up!(duration)
    update!(
      level: level + 1,
      status: :pending,
      completed_at: Time.current + duration
    )
  end
end
