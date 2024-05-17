class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.integer :weight, default: 1
      t.integer :categories, array: true, default: []
      t.text :description
      t.integer :brand_id, default: 0
      t.integer :inventory_level, default: 0

      t.timestamps
    end
  end
end
