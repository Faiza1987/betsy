class RemoveColumnAddressInOrderModel < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :address, :string
  end
end
