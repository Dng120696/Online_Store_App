class RemoveColumnFromAddress < ActiveRecord::Migration[7.1]
  def change
    remove_column :addresses, :email, :string
    remove_column :addresses, :address_type, :string
  end
end
