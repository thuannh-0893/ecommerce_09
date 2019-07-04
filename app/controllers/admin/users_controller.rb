class Admin::UsersController < Admin::BaseController
  before_action :find_user, except: %i(new create index)

  authorize_resource

  def index
    @users = User.by_name.page(params[:page]).per Settings.products.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:info] = t "helpers.success[added_user]"
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "helpers.success[update_user]"
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "helpers.success[deleted_user]"
    else
      flash[:danger] = t "helpers.error[delete_failed]"
    end
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :phone, :address, :avatar
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "helpers.error[user_not_found]"
    redirect_to admin_path
  end
end
