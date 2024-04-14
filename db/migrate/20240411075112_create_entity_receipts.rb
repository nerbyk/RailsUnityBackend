class CreateEntityReceipts < ActiveRecord::Migration[7.1]
  def change
    create_table :entity_receipts do |t|
      t.references :entity, null: false, foreign_key: true
      t.string :name, null: false

      t.integer :status, null: false, default: 0
      t.integer :level, null: false, default: 1

      t.datetime :completed_at, null: true
    end

    add_index :entity_receipts, [:completed_at, :status]
  end
end
