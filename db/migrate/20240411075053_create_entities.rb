class CreateEntities < ActiveRecord::Migration[7.1]
  def change
    enable_extension("uuid-ossp")

    create_table :entities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :farm, null: false, foreign_key: true
      t.string :guid, null: false, default: -> { "uuid_generate_v4()" }
      t.string :name, null: false
      t.box :location, null: false

      t.timestamps
    end

    add_index :entities, [:farm_id, :guid], unique: true
    add_index :entities, :location, using: :gist
  end
end
