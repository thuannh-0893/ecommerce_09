class RequestsController < ApplicationController
  authorize_resource class: RequestsController

  before_action :find_request, except: %i(new create index)
  before_action :sub_cat, except: %i(index show destroy)

  def index
    @requests = Product.user_request(current_user.id)
                       .by_updated_at.page(params[:page])
                       .per Settings.products.per_page
  end

  def show; end

  def new
    @request = Product.new
    @picture = @request.item_photos.build
  end

  def create
    @request = current_user.products.new request_params
    Product.transaction do
      @request.save!
      params[:item_photos]["photo"].each do |a|
        @picture = @request.item_photos.create!(photo: a)
      end
      add_activity "request.create"
      flash[:info] = t "helpers.success[added_product]"
      redirect_to requests_path
    end
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit; end

  def update
    Product.transaction do
      @request.update_attributes! request_params
      if params[:item_photos].present?
        params[:item_photos]["photo"].each do |a|
          @picture = @request.item_photos.create!(photo: a)
        end
      end
      add_activity "request.update"
      flash[:success] = t "helpers.success[update_product]"
      redirect_to requests_path
    end
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    return if @request.activated?
    if @request.destroy
      flash[:success] = t "helpers.success[deleted_product]"
    else
      flash[:danger] = t "helpers.error[delete_failed]"
    end
    redirect_to requests_path
  end

  private

  def request_params
    params.require(:product).permit :name, :category_id, :price, :description,
      item_photos_attributes: [:id, :product_id, :photo]
  end

  def find_request
    @request = Product.find_by id: params[:id]
    return if @request
    flash[:danger] = t "helpers.error[product_not_found]"
    redirect_to requests_path
  end

  def sub_cat
    @sub_categories = Category.sub_only.by_name
  end

  def add_activity key
    create_notification Product.name, @request,
      key, User.admin.first
  end
end
