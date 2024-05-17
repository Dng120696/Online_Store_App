class AddReferenceToProduct < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :admin, null: false, foreign_key: true

  end
end
