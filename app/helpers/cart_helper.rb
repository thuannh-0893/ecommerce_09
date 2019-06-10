module CartHelper
  def add_product product_id, quantity = 1
    check_cookie_cart
    if @products.key? product_id
      @products[product_id] += quantity
    else
      @products[product_id] = quantity
    end
    update_cookie_cart @products
  end

  def check_cookie_cart
    @products = cookies[:products]
    return @products = Hash.new if @products.blank?
    @products = JSON.parse cookies[:products]
  end

  def update_cookie_cart products
    cookies.permanent[:products] = JSON.generate products
  end

  def size_cart
    check_cookie_cart
    @products.size
  end

  def get_subtotal_price products
    products.reduce(0) do |sum, product|
      sum + product.get_total_price
    end
  end

  def delete_product product_id
    check_cookie_cart
    return @products unless @products.key?(product_id)
    @products.delete product_id
    update_cookie_cart @products
  end

  def update_quantity_product product_id, quantity
    check_cookie_cart
    @products[product_id] = quantity
    update_cookie_cart @products
  end

  def price_discounted price, discount
    @price_discounted = price - (price * discount / 100)
  end

  def total_price quantity, price
    @total_price = quantity * price
  end

  def list_products_cart products_in_cart
    @products = Product.find_product_id(products_in_cart.keys)
    @products.each do |p|
      p.total_quantity = products_in_cart[p.id.to_s].to_i
      p.price_discounted = price_discounted p.price, p.discount
    end
  end
end
