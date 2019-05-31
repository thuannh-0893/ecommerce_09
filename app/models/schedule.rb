class Schedule < ApplicationRecord
  has_many :product_schedules, dependent: :destroy
  has_many :products, through: :products_schedules

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :discount, presence: true
end
