class Admin::AdminPagesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  before_action :load_categories

  def index
    @number_requests = Product.not_yet_activate.count :id
    @number_orders = Order.pending.count :id
  end
end
