module ProductsHelper
  def overall product
    @overall = product.rates.average(:rating)
    @overall = 0 if @overall.blank?
  end

  def new_history_view
    check_history_view_product @product.id
    check_history_view_quatity
    @history_view = HistoryView.new user_id: current_user.id,
      product_id: @product.id
    @history_view.save
  end

  def check_history_view_quatity
    length = current_user.history_views.length
    length_request = Settings.products.history_view
    current_user.history_views.first.destroy if length == length_request
  end

  def check_history_view_product product_id
    current_user.history_views.each do |h|
      h.destroy if h.product_id == product_id
    end
  end
end
