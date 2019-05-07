class AddColumnPhotoUrlToProductModel < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :photo_url, :string
  end
end
