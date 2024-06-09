class RenameAddressesToAddress < ActiveRecord::Migration[7.1]
  def change
    rename_table :addresses, :address
  end
end
