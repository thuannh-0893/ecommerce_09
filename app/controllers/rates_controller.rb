class RatesController < ApplicationController
  include RatesHelper
  before_action :find_review, only: :destroy
  before_action :find_product, only: %i(create destroy)
  authorize_resource

  def create
    product_id = params[:product_id]
    @rate = Rate.new product_id: product_id,
      rating: params[:rating], content: params[:content],
      user_id: current_user.id
    Rate.transaction do
      @rate.save
      load_reviews
      renderhtml_reviews @reviews, product_id
      update_rating_and_render
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to product_path id: product_id
  end

  def destroy
    Rate.transaction do
      @review.destroy
      load_reviews
      renderhtml_reviews @reviews, params[:product_id]
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
    @product.update_attribute :rating, overall
    render json: {
      overall: overall,
      counter_reviews: @reviews.count(:rating),
      reviews: @reviews_html
    }
  end

  def find_review
    @review = Rate.find_by id: params[:review_id]
    return if @review
    flash[:danger] = t "helpers.error[review_not_found]"
    redirect_back_or product_path id: params[:product_id]
  end

  def find_product
    @product = Product.activated.find_by id: params[:product_id]
    return if @product
    flash[:danger] = t "helpers.error[product_not_found]"
    redirect_to shop_path
  end
end
