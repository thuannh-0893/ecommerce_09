class OrdersController < ApplicationController
  before_action :logged_in_user, only: :new
  authorize_resource

  def new
    products_in_cart = check_cookie_cart
    list_products_cart products_in_cart
    @order = Order.new
  end

  def create
    products_in_cart = check_cookie_cart
    list_products_cart products_in_cart
    @order = Order.new order_params.merge(user_id: current_user.id,
      status: :pending, total_price: get_subtotal_price(@products))
    ActiveRecord::Base.transaction do
      if @order.save
        begin
          save_product_order @products
        rescue StandardError
          flash[:danger] = t "helpers.error[create-order-fail-save]"
          render :new
        end
      else
        flash[:danger] = t "helpers.error[create-order-fail]"
        render :new
      end
    end
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
    flash[:info] = t "helpers.info[create-order]"
    redirect_to root_url
  end
end
