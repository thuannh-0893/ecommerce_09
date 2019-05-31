class Admin::ChartsController < Admin::BaseController
  authorize_resource class: false

  def index
    @product_by_cat = Product.select(:category_id).group(:category_id).count
    @product_by_cat.keys.each do |p|
      @product_by_cat[Category.find_by(id: p).name] = @product_by_cat.delete(p)
    end
    @user_by_day = User.group_by_day(:created_at).count
    @order_by_day = Order.group_by_day_of_week(:created_at, format: "%a").count
  end
end
