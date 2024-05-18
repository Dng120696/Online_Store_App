class AddReferenceToCategories < ActiveRecord::Migration[7.1]
  def change
    add_reference :categories, :admin, null: false, foreign_key: true
  end
end
