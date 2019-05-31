class RatesController < ApplicationController
  include RatesHelper
  def create
    @rate = Rate.new product_id: params[:product_id],
      rating: params[:rating], content: params[:content],
      user_id: current_user.id
    @rate.save
    load_reviews
    renderhtml_reviews @reviews
    render json: {
      overall: @reviews.average(:rating).round(1),
      counter_reviews: @reviews.count(:rating),
      reviews: @reviews_html
    }
  end

  private

  def load_reviews
    @reviews = Rate.product_reviews(params[:product_id]).by_date
    return if @reviews
    flash.now[:danger] = t "helpers.error[review_not_found]"
  end
end
