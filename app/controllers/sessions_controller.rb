class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate params[:session][:password]
      log_in @user
      redirect_back_or root_path
    else
      flash.now[:danger] = t "helpers.error[login]"
      render :new
    end
  end

  def destroy
    log_out if user_signed_in?
    redirect_to root_url
  end
end
