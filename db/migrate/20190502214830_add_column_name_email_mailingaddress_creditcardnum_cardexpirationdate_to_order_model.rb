class AddColumnNameEmailMailingaddressCreditcardnumCardexpirationdateToOrderModel < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :name, :string
    add_column :orders, :email, :string
    add_column :orders, :mailing_address, :string
    add_column :orders, :credit_card_num, :string
    add_column :orders, :card_expiration_date, :date
  end
end
