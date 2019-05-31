class Admin::ProductsController < Admin::BaseController
  authorize_resource

  before_action :find_product, except: %i(new create index import)
  before_action :sub_cat, except: %i(index show destroy)

  def index
    list_product
    respond_to do |format|
      format.html
      format.xls{send_data Product.to_csv, filename: "product.xls"}
      format.csv do
        if params[:template].present?
          send_data Product.to_csv_template, filename: "template.csv"
        else
          send_data Product.to_csv, filename: "product.csv"
        end
      end
    end
  end

  def new
    @admin_product = Product.new
    @picture = @admin_product.item_photos.build
  end

  def create
    @admin_product = Product.new product_params
    @admin_product.activated = true
    @admin_product.user_id = current_user.id
    Product.transaction do
      @admin_product.save
      params[:item_photos]["photo"].each do |a|
        @picture = @admin_product.item_photos.create!(photo: a)
      end
      flash[:info] = t "helpers.success[added_product]"
      redirect_to admin_products_path
    end
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit; end

  def update
    Product.transaction do
      @admin_product.update_attributes product_params
      if params[:item_photos].present?
        params[:item_photos]["photo"].each do |a|
          @picture = @admin_product.item_photos.create!(photo: a)
        end
      end
      flash[:success] = t "helpers.success[update_product]"
      redirect_to admin_products_path
    end
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    if @admin_product.destroy
      flash[:success] = t "helpers.success[deleted_product]"
    else
      flash[:danger] = t "helpers.error[delete_failed]"
    end
    redirect_to admin_products_path
  end

  def import
    if params[:file].present?
      Product.import(params[:file].path, current_user)
      flash[:success] = t("helpers.success[product_import]")
    end
    redirect_to admin_products_path
  end

  private

  def product_params
    params.require(:product).permit :name, :category_id,
      :price, :discount, :quantity, :description,
      item_photos_attributes: [:id, :photo]
  end

  def find_product
    @admin_product = Product.activated.find_by id: params[:id]
    return if @admin_product
    flash[:danger] = t "helpers.error[product_not_found]"
    redirect_to admin_products_path
  end

  def sub_cat
    @sub_categories = Category.sub_only.by_name
  end

  def list_product
    @products = Product.activated.by_updated_at.page(params[:page])
                       .per Settings.products.per_page
  end
end
