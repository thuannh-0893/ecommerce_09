class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.integer :quantity, default: 0
      t.float :rating, default: 0
      t.integer :views, default: 0
      t.text :description
      t.float :discount, default: 0
      t.references :category, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
