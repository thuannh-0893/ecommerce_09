class StaticPagesController < ApplicationController
  def home
    @new_products = Product.activated.lasted.limit Settings.products.per_page
    @saleoff_products = Product.activated.high_discount
                               .limit Settings.products.per_page
  end

  def contact; end

  def about; end
end
