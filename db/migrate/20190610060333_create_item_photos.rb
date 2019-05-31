class CreateItemPhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :item_photos do |t|
      t.bigint :product_id
      t.string :photo

      t.timestamps
    end
  end
end
