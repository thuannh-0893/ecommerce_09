class CreateProductSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :product_schedules do |t|
      t.references :schedule, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
