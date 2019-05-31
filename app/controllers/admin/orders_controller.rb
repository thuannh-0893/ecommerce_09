class Admin::OrdersController < Admin::BaseController
  before_action :find_order, only: %i(update)

  authorize_resource

  def index
    @orders = Order.by_created_at.includes(:products_orders, :products)
                   .page(params[:page]).per Settings.products.per_page
  end

  def update
    return if @order.canceled? || @order.completed?
    case params[:status]
    when statuses(:processing)
      key = statuses :processing
    when statuses(:completed)
      key = statuses :completed
    when statuses(:canceled)
      key = statuses :canceled
    else
      flash[:danger] = t "helpers.error[update_order_fail]"
      redirect_to admin_orders_path
      return
    end
    action_status key
    redirect_when_success
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

  def action_status key
    if key == statuses(:processing)
      @order.processing!
      create_notification Order.name, @order,
        "order.processing", @order.user
    elsif key == statuses(:completed)
      @order.completed!
      create_notification Order.name, @order,
        "order.completed", @order.user
    elsif key == statuses(:canceled)
      @order.canceled!
      create_notification Order.name, @order,
        "order.canceled", @order.user
    end
  rescue ArgumentError
    redirect_when_error
  end

  def redirect_when_success
    flash[:success] = t "helpers.success[updated_order]"
    redirect_to admin_orders_path
  end

  def redirect_when_error
    flash[:danger] = t "helpers.error[update_order_fail]"
    redirect_to admin_orders_path
  end
end
