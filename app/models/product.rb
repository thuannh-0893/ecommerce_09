class Product < ApplicationRecord
  include SearchCop
  require "csv"

  belongs_to :category
  belongs_to :user
  has_many :history_views, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :products_orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :item_photos, dependent: :destroy

  delegate :name, to: :category, prefix: true

  accepts_nested_attributes_for :item_photos, allow_destroy: true,
    reject_if: proc{|attributes| attributes["photo"].blank?}

  validates :category_id, presence: true

  scope :by_updated_at, ->{order updated_at: :desc}
  scope :find_product_id, ->(id){where id: id}
  scope :lasted, ->{order created_at: :desc}
  scope :high_discount, ->{order discount: :desc}
  search_scope :search do
    attributes all: [:name, :description]
    options :all, type: :fulltext
    attributes category: "category.name"
    options :category, type: :fulltext
  end
  scope :not_yet_activate, ->{where activated: false}
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
  scope :rating, (lambda do |rating_option|
    return if rating_option.nil?
    where("rating > ?", rating_option)
  end)
  scope :price_min, (lambda do |price_min|
    return if price_min.nil?
    where("price > ?", price_min)
  end)
  scope :price_max, (lambda do |price_max|
    return if price_max.nil?
    where("price < ?", price_max)
  end)
  scope :by_category_id, (lambda do |category_id|
    return if category_id.nil?
    category = Category.sub_categories_or(category_id)
    where category_id: category if category.any?
  end)
  scope :by_hot_trend, (lambda do |hot_trend|
    case hot_trend
    when "hot-trend"
      order(views: :desc)
    when "new-products"
      order(id: :desc)
    when "sale-off"
      order(discount: :desc)
    when "high-rating"
      order(rating: :desc)
    end
  end)

  attr_accessor :total_quantity, :price_discounted

  def get_total_price
    return price_discounted * total_quantity if total_quantity.present?
    price_discounted
  end

  class << self
    def import file_path, current_user
      CSV.foreach(file_path, headers: true) do |row|
        product_hash = row.to_hash
        Product.create!(product_hash.merge(user_id: current_user.id))
      end
    end

    def to_csv
      CSV.generate do |csv|
        csv << column_names
        all.each do |product|
          csv << product.attributes.values_at(*column_names)
        end
      end
    end

    def to_csv_template
      column_names = %w(name description category_id quantity price)
      product = Product.new Settings.products.column_names.to_hash
      CSV.generate do |csv|
        csv << column_names
        csv << product.attributes.values_at(*column_names)
      end
    end
  end
end
