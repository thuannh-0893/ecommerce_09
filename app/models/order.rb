class Order < ApplicationRecord
  belongs_to :user
  has_many :products_orders, dependent: :destroy
end
