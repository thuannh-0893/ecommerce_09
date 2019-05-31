class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :phone
      t.string :address
      t.string :avatar
      t.integer :role, null: false, default: 0
      t.string :activation_digest
      t.string :reset_digest
      t.string :remember_digest
      t.boolean :activated, default: false

      t.timestamps
    end
  end
end
