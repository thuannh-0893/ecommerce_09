class StaticPagesController < ApplicationController
  before_action :list_categories

  def home
    @products = Product.all.paginate page: params[:page],
      per_page: Settings.products.per_page
  end

  def contact; end

  def about; end
end
