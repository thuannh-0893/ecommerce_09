class Admin::ProductsController < Admin::BaseController
  before_action :find_product, except: %i(new create index import)
  before_action :sub_cat, except: %i(show destroy)

  authorize_resource

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

  def edit
    photos = @admin_product.item_photos
    return if photos.any?
    @picture = photos.build
  end

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
      counter = Product.import_file params[:file],
        params[:overwrite], current_user
      render_flash counter
      flash[:success] = t("helpers.success[product_create]",
        counter: counter[:counter_create])
    else
      flash[:danger] = t("helpers.error[product_import]")
    end
    redirect_to admin_products_path
  end

  def export
    @admin_products = Product.order(category_id: :desc)
    respond_to do |format|
      format.xlsx
      format.pdf do
        render pdf: "products",
          layout: "pdf.html",
          template: "admin/products/products.pdf.html.erb",
          footer: {right: "[page]"},
          margin: {top: Settings.margin_layout.top,
                   bottom: Settings.margin_layout.bot,
                   left: Settings.margin_layout.left,
                   right: Settings.margin_layout.right},
          orientation: "Portrait", page_size: "A4"
      end
    end
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
    @search = Product.activated.search(params[:q])
    @products = @search.result.paginate page: params[:page],
      per_page: Settings.products.per_page
  end

  def render_flash counter
    if params[:overwrite].present?
      flash[:info] = t("helpers.success[product_update]",
        counter: counter[:counter_update])
    else
      flash[:warning] = t("helpers.success[product_update_ignore]",
        counter: counter[:counter_update])
    end
    flash[:danger] = t("helpers.success[product_wrong_category]",
      counter: counter[:counter_wrong_category])
  end
end
