class AddColumnToOrderItems < ActiveRecord::Migration[7.1]
  def change
    add_column :order_items, :quantity, :integer, default: 1
    add_column :order_items, :price, :integer, default: 0
  end
end
