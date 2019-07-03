class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_notification, only: :update

  def index
    @notifications_all = Notification.correct_user(current_user.id)
                                     .by_updated
                                     .paginate page: params[:page],
                                        per_page: Settings.per_page
  end

  def update
    @notification.update_attribute :read, 1
    render json: {
      success: "success"
    }
  end

  private

  def find_notification
    @notification = Notification.find_by(id: params[:id])
    return if @notification
    flash[:danger] = t "helpers.error[notification_not_found]"
    redirect_to root_path
  end
end
