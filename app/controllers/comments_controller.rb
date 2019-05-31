class CommentsController < ApplicationController
  include CommentsHelper

  def create
    @comment = Comment.new product_id: params[:product_id],
      parent_id: params[:parent_id], content: params[:comment],
      user_id: current_user.id
    @comment.save
    load_comments
    renderhtml_comments @comments
    render json: {
      comments: @comments_html
    }
  end

  private

  def load_comments
    @comments = Comment.product_comments_parrent(params[:product_id]).by_date
    return if @comments
    flash.now[:danger] = t "helpers.error[comment_not_found]"
    redirect_back_or product_path id: params[:product_id]
  end
end
