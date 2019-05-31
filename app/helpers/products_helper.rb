module ProductsHelper
  def overall product
    @overall = product.rates.average(:rating)
    @overall = 0 if @overall.blank?
  end
end
