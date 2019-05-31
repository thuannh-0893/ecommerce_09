class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :find_order, only: :show

  def show; end

  def new
    products_in_cart = check_cookie_cart
    list_products_cart products_in_cart
    return @order = Order.new if @products.any?
    flash[:danger] = t "helpers.info[access_denied]"
    redirect_to index_cart_path
  end

  def create
    products_in_cart = check_cookie_cart
    list_products_cart products_in_cart
    @order = Order.new order_params.merge(user_id: current_user.id,
      status: :pending, total_price: get_subtotal_price(@products))
    Order.transaction do
      @order.save
      save_product_order @products
      flash[:info] = t "helpers.info[create-order]"
      redirect_to order_path(@order)
    end
  rescue StandardError
    flash[:danger] = t "helpers.error[create-order-fail-save]"
    render :new
  end

  private

  def order_params
    params.require(:order).permit :receiver_name, :receiver_phone,
      :receiver_address, :description
  end

  def save_product_order products
    products.each do |p|
      @products_order = @order.products_orders.new(product_id: p.id,
        quantity: p.total_quantity, actual_price: p.price_discounted)
      @products_order.save
    end
    cookies.delete :products
    # OrderMailer.order_complete(current_user, @order).deliver_now
  end

  def find_order
    @order = Order.find_by(id: params[:id])
    return if @order
    flash[:danger] = t "helpers.error[order_not_found]"
    redirect_to cart_path
  end
end
