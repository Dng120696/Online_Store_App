class AddProvinceColumnToAddresses < ActiveRecord::Migration[7.1]
  def change
    add_column :addresses, :state_or_province, :string
  end
end
