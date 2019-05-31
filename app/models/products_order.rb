class ProductsOrder < ApplicationRecord
  belongs_to :product
  belongs_to :order
  delegate :quantity, to: :product, prefix: true
end
