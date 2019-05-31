class CartController < ApplicationController
  before_action :load_categories

  def create
    add_product params[:product_aid], params[:qty].to_i
    render json: {size_cart: size_cart}
  end

  def update
    product_aid = params[:product_aid]
    aquantity = params[:aquantity].to_i
    update_quantity_product(product_aid, aquantity)
    products_in_cart = check_cookie_cart
    list_products_cart products_in_cart
    product = Product.find_by id: product_aid
    render json: {
      total_quantity: aquantity,
      price_discounted: price_discounted(product.price, product.discount),
      subtotal: get_subtotal_price(@products)
    }
  end

  def index
    products_in_cart = check_cookie_cart
    list_products_cart products_in_cart
  end

  def destroy
    delete_product params[:product_id]
    redirect_to cart_index_path
  end
end
