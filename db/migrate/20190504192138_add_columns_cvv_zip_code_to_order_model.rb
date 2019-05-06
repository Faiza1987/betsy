class AddColumnsCvvZipCodeToOrderModel < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :cvv, :integer
    add_column :orders, :billing_zip_code, :integer
  end
end
