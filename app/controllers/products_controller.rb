class ProductsController < ApplicationController
  include ProductsHelper

  before_action :load_categories, except: %i(destroy show)
  before_action :find_product, except: %i(new create index filter)

  def index
    shop_parmas = params.slice(:rating,
      :price_min, :price_max, :sort, :shop, :cat)
    if shop_parmas.blank?
      @products = Product.by_updated_at
    elsif params[:shop].present?
      @products = Product.by_hot_trend(params[:shop])
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

  def new
    @products = Product.new
  end

  def create
    @product = Product.new product_params
    @product.user_id = current_user.id
    if @product.save
      flash[:info] = t "helpers.success[added_product]"
      redirect_to shop_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @admin_product.update_attributes product_params
      flash[:success] = t "helper.success[update_product]"
      redirect_to shop_path
    else
      render :edit
    end
  end

  def destroy
    if @admin_product.destroy
      flash[:success] = t "helper.success[deleted_product]"
    else
      flash[:danger] = t "helper.error[delete_failed]"
    end
    redirect_to shop_path
  end

  private

  def product_params
    params.require(:product).permit :name, :picture, :category_id,
      :price, :discount, :quantity, :description
  end

  def find_product
    @product = Product.find_by id: params[:id]
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
