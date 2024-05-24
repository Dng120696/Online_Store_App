class RenameColumnFromAddresses < ActiveRecord::Migration[7.1]
  def change
    rename_column :addresses, :zip, :zip_code
  end
end
