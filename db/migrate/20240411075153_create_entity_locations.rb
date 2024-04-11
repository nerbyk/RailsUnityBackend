class CreateEntityLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :entity_locations do |t|
      t.references :entity, null: false, foreign_key: { on_delete: :cascade }
      t.bigint :farm_id, null: false
      t.integer :x
      t.integer :y

      t.timestamps
    end

    add_index :entity_locations, [:farm_id, :x, :y], unique: true
  end
end
