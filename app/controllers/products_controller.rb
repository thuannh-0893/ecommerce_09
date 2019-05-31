class ProductsController < ApplicationController
  before_action :load_categories, except: %i(destroy show)
  before_action :find_product, except: %i(new create index)

  def index
    @products = Product.by_updated_at.paginate page: params[:page],
      per_page: Settings.products.per_page
  end

  def show; end

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
end
