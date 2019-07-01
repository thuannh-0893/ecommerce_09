module CommentsHelper
  def renderhtml_comments comments, product_id
    @comments_html = Array.new
    comments.each do |comment|
      append_div comment, product_id
      @comments_html << @div
    end
    @comment_html
  end

  def append_div comment, product_id
    @div = "<div class='comment_item'>"
    @div += "<div class='media'>"
    @div += "<div class='d-flex'>"
    @div += "<img src='" + comment.user.avatar.url + "'>"
    @div += "</div>"
    @div += "<div class='media-body'>"
    @div += "<h4>" + comment.user.name + "</h4>"
    append_div_cont1 comment, product_id
    append_div_cont2 comment, product_id
  end

  def append_div_cont1 comment, product_id
    @div += "<h5>" + l(comment.updated_at, format: :short) + "</h5>"
    if comment.user.id == current_user.id
      @div += "<a class='delete_btn' data_id='" + comment.id.to_s + "'"
      @div += "pid='" + product_id + "' href='javascript:void(0)'>"
      @div += t("products.comment.delete") + "</a>"
    end
    append_div_cont1_1 comment
  end

  def append_div_cont1_1 comment
    @div += "<a class='reply_btn' parent_id='" + comment.id.to_s + "' user='"
    @div += comment.user.name + "' href='javascript:void(0)'>"
    @div += t("products.comment.reply") + "</a>"
    @div += "</div>"
    @div += "</div>"
    @div += "<p>" + comment.content + "</p>"
    @div += "</div>"
  end

  def append_div_cont2 comment, product_id
    reply_comments = Comment.reply_comments(comment.id).by_date
    reply_comments.each do |reply_comment|
      @div += "<div class='reply_comment_item reply'"
      @div += "data='" + comment.id.to_s + "'>"
      @div += "<div class='media'>"
      @div += "<div class='d-flex'>"
      @div += "<img src='" + reply_comment.user.avatar.url + "'>"
      @div += "</div>"
      append_div_cont3 comment, reply_comment, product_id
    end
    append_div_cont5 comment, reply_comments
  end

  def append_div_cont3 comment, reply_comment, product_id
    @div += "<div class='media-body'>"
    @div += "<h4>" + reply_comment.user.name + "</h4>"
    @div += "<h5>" + l(reply_comment.updated_at, format: :short) + "</h5>"
    append_div_cont3_1 reply_comment, product_id
    @div += "<a class='reply_btn' parent_id='" + comment.id.to_s + "' user='"
    append_div_cont4 reply_comment
  end

  def append_div_cont3_1 reply_comment, product_id
    return unless reply_comment.user.id == current_user.id
    @div += "<a class='delete_btn' data_id='" + reply_comment.id.to_s + "'"
    @div += "pid='" + product_id + "' href='javascript:void(0)'>"
    @div += t("products.comment.delete") + "</a>"
  end

  def append_div_cont4 reply_comment
    @div += reply_comment.user.name + "' href='javascript:void(0)'>"
    @div += t("products.comment.reply") + "</a>"
    @div += "</div>"
    @div += "</div>"
    @div += "<p>" + reply_comment.content + "</p>"
    @div += "</div>"
  end

  def append_div_cont5 comment, reply_comments
    return unless reply_comments.any? && reply_comments.size > 1
    @div += "<div class='loadMoreReplyComment' data='" + comment.id.to_s + "'>"
    @div += "<a href='#'>"
    @div += t("products.comment.load_reply", count: reply_comments.size - 1)
    @div += "</a>"
    @div += "</div>"
  end
end
