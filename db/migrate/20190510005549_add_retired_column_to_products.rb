class AddRetiredColumnToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :retired, :boolean, default: false, null: false
  end
end
