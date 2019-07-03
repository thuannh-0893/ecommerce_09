class RatesController < ApplicationController
  include RatesHelper

  def create
    @rate = Rate.new product_id: params[:product_id],
      rating: params[:rating], content: params[:content],
      user_id: current_user.id
    Rate.transaction do
      @rate.save
      load_reviews
      renderhtml_reviews @reviews
      update_rating_and_render
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to product_path id: params[:product_id]
  end

  private

  def load_reviews
    @reviews = Rate.product_reviews(params[:product_id]).by_date
    return if @reviews
    flash.now[:danger] = t "helpers.error[review_not_found]"
  end

  def update_rating_and_render
    overall = @reviews.average(:rating).round(1)
    @rate.product.update_attribute :rating, overall
    render json: {
      overall: overall,
      counter_reviews: @reviews.count(:rating),
      reviews: @reviews_html
    }
  end
end
