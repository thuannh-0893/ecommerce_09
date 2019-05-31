class Product < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :history_views, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :products_orders, dependent: :destroy
  has_many :comments, dependent: :destroy

  scope :by_updated_at, ->{order(updated_at: :desc)}
  scope :find_product_id, ->(id){where id: id}

  attr_accessor :total_quantity, :price_discounted

  def get_total_price
    return price_discounted * total_quantity if total_quantity.present?
    price_discounted
  end
end
