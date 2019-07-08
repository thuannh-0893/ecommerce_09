class CommentsController < ApplicationController
  include CommentsHelper
  before_action :find_comment, only: :destroy
  authorize_resource

  def create
    @comment = Comment.new product_id: params[:product_id],
      parent_id: params[:parent_id], content: params[:comment],
      user_id: current_user.id
    @comment.save
    load_comments
    renderhtml_comments @comments, params[:product_id]
    render json: {
      comments: @comments_html
    }
  end

  def destroy
    @comment.destroy
    load_comments
    renderhtml_comments @comments, params[:product_id]
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

  def find_comment
    @comment = Comment.find_by id: params[:comment_id]
    return if @comment
    flash[:danger] = t "helpers.error[comment_not_found]"
    redirect_back_or product_path id: params[:product_id]
  end
end
