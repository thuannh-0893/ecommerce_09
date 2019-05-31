class Admin::ProductsController < ApplicationController
  before_action :load_categories
  before_action :find_product, except: %i(new create index)
  before_action :sub_cat, except: %i(index show destroy)

  def index
    @products = Product.by_updated_at.paginate page: params[:page],
      per_page: Settings.products.per_page
  end

  def new
    @admin_product = Product.new
  end

  def create
    @admin_product = Product.new product_params
    @admin_product.user_id = current_user.id
    if @admin_product.save
      flash[:info] = t "helpers.success[added_product]"
      redirect_to admin_products_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @admin_product.update_attributes product_params
      flash[:success] = t "helper.success[update_product]"
      redirect_to admin_products_path
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
    redirect_to admin_products_path
  end

  private

  def product_params
    params.require(:product).permit :name, :picture, :category_id,
      :price, :discount, :quantity, :description
  end

  def find_product
    @admin_product = Product.find_by id: params[:id]
    return if @admin_product
    flash[:danger] = t "helpers.error[product_not_found]"
    redirect_to admin_products_path
  end

  def sub_cat
    @sub_categories = Category.all.sub_only.by_name
  end
end
