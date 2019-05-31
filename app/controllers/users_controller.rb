class UsersController < ApplicationController
  before_action :find_user, only: :show

  authorize_resource

  def show; end

  private

  def find_user
    @user = User.find_by id: params[:id]
    return if @user &. confirmed?
    flash[:danger] = t "helpers.error[user]"
    redirect_to root_url
  end
end
