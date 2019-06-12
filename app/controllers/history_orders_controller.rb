class HistoryOrdersController < ApplicationController
  before_action :load_categories
  before_action :logged_in_user, only: :index

  def index
    @history_orders = current_user.orders.by_created_at
                                  .includes(:products_orders, :products)
                                  .paginate page: params[:page],
                                    per_page: Settings.products.per_page
  end
end
