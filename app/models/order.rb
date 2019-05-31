class Order < ApplicationRecord
  belongs_to :user
  has_many :products_orders, dependent: :destroy
  has_many :products, through: :products_orders
  enum status: {pending: 0, processed: 1, completed: 2, canceled: 3}
end
