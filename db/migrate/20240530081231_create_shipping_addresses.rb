class CreateShippingAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :shipping_addresses do |t|
      t.string :city
      t.string :country
      t.integer :zip_code
      t.string :street
      t.string :state_or_province
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
