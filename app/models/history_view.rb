class HistoryView < ApplicationRecord
  belongs_to :user
  belongs_to :product
  delegate :name, :price, :discount, to: :product, allow_nil: true
end
