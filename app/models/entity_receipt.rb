class EntityReceipt < ApplicationRecord
  belongs_to :entity

  enum status: { pending: 0, completed: 1 }
end
