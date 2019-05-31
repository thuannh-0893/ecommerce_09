class Product < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :history_views, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :products_orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :item_photos, dependent: :destroy

  accepts_nested_attributes_for :item_photos, allow_destroy: true,
    reject_if: proc{|attributes| attributes["photo"].blank?}

  scope :by_updated_at, ->{order updated_at: :desc}
  scope :find_product_id, ->(id){where id: id}
  scope :lasted, ->{order created_at: :desc}
  scope :high_discount, ->{order discount: :desc}
  s_query = "MATCH (name, description) AGAINST (? IN NATURAL LANGUAGE MODE)"
  scope :search, ->(keyword){where(s_query, keyword)}
  scope :select_price_discounted,
    ->{select("products.*", "price*(100-discount) as price_discounted")}

  scope :sort_product, (lambda do |sort_option|
    case sort_option
    when "sort_a_z"
      order(name: :asc)
    when "sort_z_a"
      order(name: :desc)
    when "sort_new"
      order(created_at: :desc)
    when "sort_price_a_z"
      order(price_discounted: :desc)
    when "sort_price_z_a"
      order(price_discounted: :asc)
    end
  end)
  scope :rating, ->(rating_option){where("rating > ?", rating_option)}
  scope :price_min, ->(price_min){where("price > ?", price_min)}
  scope :price_max, ->(price_max){where("price < ?", price_max)}

  attr_accessor :total_quantity, :price_discounted

  def get_total_price
    return price_discounted * total_quantity if total_quantity.present?
    price_discounted
  end
end
