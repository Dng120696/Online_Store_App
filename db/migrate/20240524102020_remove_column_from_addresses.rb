class RemoveColumnFromAddresses < ActiveRecord::Migration[7.1]
  def change
    remove_column :addresses, :firstname, :string
    remove_column :addresses, :lastname, :string
  end
end
