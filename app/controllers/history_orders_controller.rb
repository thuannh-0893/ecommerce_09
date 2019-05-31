class HistoryOrdersController < ApplicationController
  authorize_resource class: HistoryOrdersController

  def index
    @history_orders = current_user.orders.by_created_at
                                  .includes(:products_orders, :products)
                                  .page(params[:page])
                                  .per Settings.products.per_page
  end
end
