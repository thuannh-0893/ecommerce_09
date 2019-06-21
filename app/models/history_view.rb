class HistoryView < ApplicationRecord
  belongs_to :user
  belongs_to :product
  delegate :name, :price, :discount, :item_photos, to: :product, allow_nil: true
end
