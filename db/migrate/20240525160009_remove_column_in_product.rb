class RemoveColumnInProduct < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :categories, :integer

  end
end
