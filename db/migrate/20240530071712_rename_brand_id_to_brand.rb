class RenameBrandIdToBrand < ActiveRecord::Migration[7.1]
  def change
    rename_column :products, :brand_id, :brand
    change_column :products, :brand, :string, default: "N/A"
  end
end
