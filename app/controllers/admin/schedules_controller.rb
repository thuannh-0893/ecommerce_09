class Admin::SchedulesController < Admin::BaseController
  before_action :load_categories
  before_action :find_schedule, except: %i(new create index)

  authorize_resource :schedule

  def index
    @schedules = Schedule.paginate page: params[:page],
      per_page: Settings.per_page
  end

  def create
    @schedule = Schedule.new schedule_params
    product_ids = params[:product_ids]
    if product_ids.nil?
      flash[:danger] = t "helpers.error[added_schedule_not_product]"
      redirect_to admin_products_path
      return
    end
    ActiveRecord::Base.transaction do
      check_schedule_save product_ids
    end
  rescue StandardError
    flash[:danger] = t "helpers.error[added_schedule_fail_save]"
    redirect_to admin_schedules_path
  end

  def destroy
    if @schedule.destroy
      flash[:success] = t "helper.success[deleted_schedule]"
    else
      flash[:danger] = t "helper.error[delete_failed]"
    end
    redirect_to admin_schedules_path
  end

  private

  def schedule_params
    params.require(:schedule).permit :name, :start_time, :end_time, :discount
  end

  def find_schedule
    @schedule = Schedule.find_by id: params[:id]
    return if @schedule
    flash[:danger] = t "helpers.error[schedule_not_found]"
    redirect_to admin_path
  end

  def check_schedule_save product_ids
    product_ids_array = product_ids.split(",")
    if @schedule.save!
      product_ids_array.each do |p|
        @products = @schedule.product_schedules.new(product_id: p.to_i)
        @products.save
      end
      flash[:info] = t "helpers.success[added_schedule]"
      redirect_to admin_schedules_path
    else
      flash[:danger] = "helpers.error[added_schedule_fail]"
      redirect_to admin_products_path
    end
  end
end
