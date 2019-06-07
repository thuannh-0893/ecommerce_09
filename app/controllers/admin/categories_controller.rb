class Admin::CategoriesController < ApplicationController
  before_action :admin_user
  before_action :find_category, except: %i(new create index)
  before_action :list_categories
  before_action :list_parent_categories

  def index
    @categories = Category.by_name.paginate page: params[:page],
      per_page: Settings.per_page
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:info] = t "helpers.success[added_category]"
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "helper.success[update_category]"
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "helper.success[deleted_category]"
    else
      flash[:danger] = t "helper.error[delete_failed]"
    end
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit :name, :parent_id
  end

  def find_category
    @category = Category.find_by id: params[:id]
    return if @category
    flash[:danger] = t "helpers.error[category_not_found]"
    redirect_to admin_path
  end

  def list_parent_categories
    @parent_categories = Category.parent_only.by_name
  end
end
