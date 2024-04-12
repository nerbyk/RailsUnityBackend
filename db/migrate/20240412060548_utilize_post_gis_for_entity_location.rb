class UtilizePostGisForEntityLocation < ActiveRecord::Migration[7.1]
  def change
    drop_table :entity_locations
    
    add_column :entities, :location, :geometry, srid: 4326, geographic: true, null: false
    add_index :entities, :location, using: :gist
  end
end
