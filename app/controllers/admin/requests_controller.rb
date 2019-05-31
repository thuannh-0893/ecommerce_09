class Admin::RequestsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  before_action :find_product, only: %i(update destroy)

  def index
    @requests = Product.not_yet_activate.by_updated_at
                       .paginate page: params[:page],
                          per_page: Settings.products.per_page
  end

  def update
    if @request.update_attribute :activated, true
      flash[:success] = t "helpers.success[add_to_products]"
      redirect_to admin_requests_path
    else
      render :edit
    end
  end

  def destroy
    if @request.destroy
      flash[:success] = t "helpers.success[deleted_product]"
    else
      flash[:danger] = t "helpers.error[delete_failed]"
    end
    redirect_to admin_requests_path
  end

  private

  def find_product
    @request = Product.not_yet_activate.find_by id: params[:id]
    return if @request
    flash[:danger] = t "helpers.error[product_not_found]"
    redirect_to admin_requests_path
  end
end
