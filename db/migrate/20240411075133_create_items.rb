class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :farm, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :amount

      t.timestamps
    end
    
    add_index :items, [:farm_id, :name], unique: true
  end
end
