class CreateProductsOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :products_orders do |t|
      t.integer :quantity, default: 0
      t.float :actual_price
      t.references :order, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
