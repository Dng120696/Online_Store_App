class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :city
      t.string :country
      t.string :firstname
      t.string :lastname
      t.string :email
      t.integer :zip
      t.string :street
      t.string :address_type, default: 'billing'
      t.references :user, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true


      t.timestamps
    end
  end
end
