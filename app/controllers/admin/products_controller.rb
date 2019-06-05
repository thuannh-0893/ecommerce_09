class Admin::ProductsController < ApplicationController
  before_action :list_categories

  def index
    @products = Product.by_updated_at.paginate page: params[:page],
      per_page: Settings.products.per_page
  end

  def new; end
end
