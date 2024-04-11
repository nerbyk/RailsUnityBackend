class CreateEntities < ActiveRecord::Migration[7.1]
  def change
    create_table :entities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :farm, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
