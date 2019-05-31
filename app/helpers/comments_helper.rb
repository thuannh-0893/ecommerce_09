module CommentsHelper
  def renderhtml_comments comments
    @comments_html = Array.new
    comments.each do |comment|
      append_div comment
      @comments_html << @div
    end
    @comment_html
  end

  def append_div comment
    @div = "<div class='comment_item'>"
    @div += "<div class='media'>"
    @div += "<div class='d-flex'>"
    @div += "<img src='" + comment.user.avatar.url
    @div += "' width='50' height='50'>"
    @div += "</div>"
    @div += "<div class='media-body'>"
    @div += "<h4>" + comment.user.name + "</h4>"
    append_div_cont1 comment
    append_div_cont2 comment
  end

  def append_div_cont1 comment
    @div += "<h5>" + l(comment.updated_at, format: :short) + "</h5>"
    @div += "<a class='reply_btn' parent_id='" + comment.id.to_s + "' user='"
    @div += comment.user.name + "' href='javascript:void(0)'>Reply</a>"
    @div += "</div>"
    @div += "</div>"
    @div += "<p>" + comment.content + "</p>"
    @div += "</div>"
  end

  def append_div_cont2 comment
    sub_comments = Comment.sub_comments(comment.id).by_date
    sub_comments.each do |sub_comment|
      @div += "<div class='comment_item reply'>"
      @div += "<div class='media'>"
      @div += "<div class='d-flex'>"
      @div += "<img src='" + sub_comment.user.avatar.url
      @div += "' width='50' height='50'>"
      @div += "</div>"
      @div += "<div class='media-body'>"
      append_div_cont3 comment, sub_comment
    end
  end

  def append_div_cont3 comment, sub_comment
    @div += "<h4>" + sub_comment.user.name + "</h4>"
    @div += "<h5>" + l(sub_comment.updated_at, format: :short) + "</h5>"
    @div += "<a class='reply_btn' parent_id='" + comment.id.to_s + "' user='"
    @div += sub_comment.user.name + "' href='javascript:void(0)'>Reply</a>"
    append_div_cont4 sub_comment
  end

  def append_div_cont4 sub_comment
    @div += "</div>"
    @div += "</div>"
    @div += "<p>" + sub_comment.content + "</p>"
    @div += "</div>"
  end
end
