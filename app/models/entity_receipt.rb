class EntityReceipt < ApplicationRecord
  belongs_to :entity

  enum status: {pending: 0, completed: 1}

  validate :validate_level_up, on: :update

  def schema = GameplayStatic.receipts[name.to_sym]

  def validate_level_up
    return if !changes[:status].nil? && changes[:status][0] == "completed"

    errors.add(:level, "receipt can't be upgraded")
  end
end
