class CreateOrderitems < ActiveRecord::Migration[5.2]
  def change
    create_table :orderitems do |t|
      t.integer :quantity
      t.belongs_to :order, index: true
      t.belongs_to :product, index: true
      t.timestamps
    end
  end
end
