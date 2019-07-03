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
  has_many :product_schedules, dependent: :destroy

  delegate :name, to: :category, prefix: true

  accepts_nested_attributes_for :item_photos, allow_destroy: true,
    reject_if: proc{|attributes| attributes["photo"].blank?}

  validates :category_id, presence: true

  scope :by_updated_at, ->{order updated_at: :desc}
  scope :find_product_id, ->(id){where id: id}
  scope :lasted, ->{order created_at: :desc}
  scope :high_discount, ->{order discount: :desc}
  search_scope :search_product_public do
    attributes all: [:name, :description]
    options :all, type: :fulltext
    attributes category: "category.name"
    options :category, type: :fulltext
  end
  scope :activated, ->{where activated: true}
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
    def import_file file, overwrite, current_user
      init file, current_user
      import! @header, @products if @products.any?
      if @products_update.any? && overwrite.present?
        Product.import! @header, @products_update,
          on_duplicate_key_update: [:name, :price, :quantity, :category_id]
      end
      {
        counter_create: @counter_create,
        counter_update: @counter_update,
        counter_wrong_category: @counter_wrong_category
      }
    end

    def open_spreadsheet file
      case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
      end
    end

    def find_category name
      category = Category.find_by name: name
      return category.id if category
      false
    end

    def find_product id
      @product = Product.activated.find_by id: id
      return true if @product
      false
    end

    def init file, current_user
      spreadsheet = open_spreadsheet(file)
      @header = spreadsheet.row(1)
      @header[4] = "category_id"
      @header << "user_id"
      @products = []
      @products_update = []
      read_file spreadsheet, current_user
    end

    def read_file spreadsheet, current_user
      @counter_create = 0
      @counter_update = 0
      @counter_wrong_category = 0
      (2..spreadsheet.last_row).each do |i|
        @row = spreadsheet.row(i)
        category_id = find_category(@row[4])
        unless category_id
          @counter_wrong_category += 1
          next
        end
        @row[4] = category_id
        if find_product(@row[0])
          found_product
          @counter_update += 1
        else
          not_found_product current_user
          @counter_create += 1
        end
      end
    end

    def found_product
      @row << @product.user_id
      @products_update << @row
    end

    def not_found_product current_user
      @row << current_user.id
      @products << @row
    end
  end
end
