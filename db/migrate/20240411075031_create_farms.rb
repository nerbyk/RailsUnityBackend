class CreateFarms < ActiveRecord::Migration[7.1]
  def change
    create_table :farms do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
