class UsersController < ApplicationController
  authorize_resource

  before_action :correct_user, only: %i(edit update show)
  before_action :find_user, except: %i(new create index)

  def index
    @users = User.by_name.page(params[:page]).per Settings.products.per_page
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:info] = t "helpers.info[signup]"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "helpers.success[updated_profile]"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :phone, :address, :avatar
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user &. activated?
    flash[:danger] = t "helpers.error[user]"
    redirect_to root_url
  end
end
