class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.float :discount, default: 0
      t.integer :activated, default: 0

      t.timestamps
    end
  end
end
