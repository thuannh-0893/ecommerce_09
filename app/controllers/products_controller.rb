class ProductsController < ApplicationController
  include ProductsHelper
  before_action :load_categories
  before_action :find_product, only: :show

  def index
    shop_parmas = params.slice(:rating,
      :price_min, :price_max, :sort, :shop, :cat)
    if shop_parmas.blank?
      @products = Product.activated.by_updated_at
    elsif params[:shop].present?
      @products = Product.activated.by_hot_trend(params[:shop])
    else
      filter
    end
    @products = @products.paginate page: params[:page],
      per_page: Settings.products.per_page
  end

  def show
    new_history_view
    @comments = Comment.product_comments_parrent(params[:id]).by_date
    @reviews = Rate.product_reviews(params[:id]).by_date
  end

  private

  def find_product
    @product = Product.activated.find_by id: params[:id]
    return if @product
    flash[:danger] = t "helpers.error[product_not_found]"
    redirect_to shop_path
  end

  def filter
    @products = Product.select_price_discounted
                       .rating(params[:rating])
                       .price_min(params[:price_min])
                       .price_max(params[:price_max])
                       .by_category_id(params[:cat])
                       .sort_product(params[:sort])
  end
end
