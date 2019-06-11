class StaticPagesController < ApplicationController
  def home
    @new_products = Product.lasted.limit Settings.products.per_page
    @saleoff_products = Product.high_discount.limit Settings.products.per_page
  end

  def contact; end

  def about; end
end
