class Admin::OrdersController < Admin::BaseController
  before_action :find_order, only: %i(update)

  authorize_resource

  def index
    @orders = Order.by_created_at.includes(:products_orders, :products)
                   .paginate page: params[:page],
                     per_page: Settings.products.per_page
  end

  def update
    return if @order.canceled? || @order.completed?
    case params[:status]
    when statuses(:processing)
      @order.processing!
    when statuses(:completed)
      @order.completed!
    when statuses(:canceled)
      @order.canceled!
    else
      flash[:danger] = t "helpers.error[update_order_fail]"
      redirect_to admin_orders_path
      return
    end
    flash[:success] = t "helpers.success[updated_order]"
    redirect_to admin_orders_path
  end

  private

  def find_order
    @order = Order.find_by id: params[:id]
    return if @order
    flash[:danger] = t "helpers.error[order_not_found]"
    redirect_to admin_orders_path
  end

  def statuses status
    Order.statuses[status].to_s
  end
end
