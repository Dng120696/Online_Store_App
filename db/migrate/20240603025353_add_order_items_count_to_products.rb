class AddOrderItemsCountToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :order_items_count, :integer, default: 0, null: false
  end
end
