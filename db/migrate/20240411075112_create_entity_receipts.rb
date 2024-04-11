class CreateEntityReceipts < ActiveRecord::Migration[7.1]
  def change
    create_table :entity_receipts do |t|
      t.references :entity, null: false, foreign_key: true
      t.string :name, null: false
      t.string :state, null: false

      t.timestamps
    end
  end
end
