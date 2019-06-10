class SearchsController < ApplicationController
  before_action :load_categories

  def index
    @products = Product.by_updated_at
    @products = if params[:keyword] != ""
                  @products.search(params[:keyword])
                else
                  @products
                end.paginate page: params[:page],
                    per_page: Settings.products.per_page
  end

  private

  def search_params
    params.require(:product).permit :keyword
  end
end
