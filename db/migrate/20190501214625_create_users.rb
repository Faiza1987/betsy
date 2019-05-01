class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.integer :uid
      t.string :provider
      t.string :email

      t.timestamps
    end
  end
end
