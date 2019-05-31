class Order < ApplicationRecord
  belongs_to :user
  has_many :products_orders, dependent: :destroy
  has_many :products, through: :products_orders
  enum status: {pending: 0, processing: 1, completed: 2, canceled: 3}
  scope :find_user_id, ->(user_id){where user_id: user_id}
  scope :by_created_at, ->{order created_at: :desc}

  validates :receiver_name, presence: true,
    length: {maximum: Settings.user.name.max_length}
  validates :receiver_phone, presence: true, numericality: true
  validates :receiver_address, presence: true
  validates :description, presence: true
end
