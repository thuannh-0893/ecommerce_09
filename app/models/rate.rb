class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :product

  attr_accessor :user_avatar

  scope :product_reviews, ->(id){where product_id: id}
  scope :by_date, ->{order updated_at: :desc}
end
