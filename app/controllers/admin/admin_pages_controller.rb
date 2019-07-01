class Admin::AdminPagesController < Admin::BaseController
  authorize_resource class: false

  def index
    @number_requests = Product.not_yet_activate.count :id
    @number_orders = Order.pending.count :id
  end
end
