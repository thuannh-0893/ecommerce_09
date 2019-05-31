class CreateHistoryViews < ActiveRecord::Migration[5.2]
  def change
    create_table :history_views do |t|
      t.datetime :viewed_at
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
