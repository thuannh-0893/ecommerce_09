module RatesHelper
  def renderhtml_reviews reviews
    @reviews_html = Array.new
    reviews.each do |review|
      append_div review
      @reviews_html << @div
    end
    @review_html
  end

  def append_div review
    @div = "<div class='review_item' style='display:none'>"
    @div += "<div class='media'>"
    @div += "<div class='d-flex'>"
    @div += "<img src='" + review.user.avatar.url + "' width='50' height='50'>"
    @div += "</div>"
    @div += "<div class='media-body'>"
    @div += "<h4>" + review.user.name + "</h4>"
    append_div_cont review
  end

  def append_div_cont review
    @div += "<h4>" + l(review.updated_at, format: :short) + "</h4>"
    review.rating.times.each do
      @div += "<i class='fa fa-star'></i>"
    end
    @div += "</div>"
    @div += "</div>"
    @div += "<p>" + review.content + "</p>"
    @div += "</div>"
  end
end
