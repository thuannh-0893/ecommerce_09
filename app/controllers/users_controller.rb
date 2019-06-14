class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)
  before_action :find_user, except: %i(new create index)

  def index
    @users = User.by_name.paginate page: params[:page],
      per_page: Settings.per_page
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

  def destroy
    if @user.destroy
      flash[:success] = t "helpers.success[deleted_user]"
    else
      flash[:danger] = t "helpers.error[fail_to_delete]"
    end
    redirect_to users_url
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
