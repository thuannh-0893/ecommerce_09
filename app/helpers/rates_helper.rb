module RatesHelper
  def renderhtml_reviews reviews, product_id
    @reviews_html = Array.new
    reviews.each do |review|
      append_div review, product_id
      @reviews_html << @div
    end
    @review_html
  end

  def append_div review, product_id
    @div = "<div class='review_item' style='display:none'>"
    @div += "<div class='media'>"
    @div += "<div class='d-flex'>"
    @div += "<img src='" + review.user.avatar.url + "' width='50' height='50'>"
    @div += "</div>"
    @div += "<div class='media-body'>"
    @div += "<h4>" + review.user.name + "</h4>"
    append_div_cont review, product_id
  end

  def append_div_cont review, product_id
    @div += "<h4>" + l(review.updated_at, format: :short) + "</h4>"
    if review.user.id == current_user.id
      @div += "<a class='delete_review_btn' data_id='" + review.id.to_s + "'"
      @div += "pid='" + product_id + "' href='javascript:void(0)'>"
      @div += t("products.review.delete") + "</a>"
    end
    append_div_cont2 review
  end

  def append_div_cont2 review
    review.rating.times.each do
      @div += "<i class='fa fa-star'></i>"
    end
    @div += "</div>"
    @div += "</div>"
    @div += "<p>" + review.content + "</p>"
    @div += "</div>"
  end
end
