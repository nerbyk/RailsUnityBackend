class AddGuidToEntities < ActiveRecord::Migration[7.1]
  def change
    enable_extension('uuid-ossp')

    add_column :entities, :guid, :string, null: false, default: -> { 'uuid_generate_v4()' }
    add_index :entities, [:farm_id, :guid], unique: true
  end
end
