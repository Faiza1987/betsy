class AddColumnStatusToOrderitem < ActiveRecord::Migration[5.2]
  def change
    add_column :orderitems, :status, :string
  end
end
