class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform count, notification
    id = notification.recipient_id
    notifications = Notification.correct_user(id)
                                .by_updated.limit Settings.notifications
    ActionCable.server.broadcast "notification_channel_#{id}",
      counter: render_count_notification(count),
      notifications: render_notifications(notifications)
  end

  def render_count_notification count
    ApplicationController.render partial: "shared/count_notification",
      locals: {count_notification: count}
  end

  def render_notifications notifications
    @notifications = Array.new
    notifications.each do |notification|
      if notification.trackable_type == "Product"
        product_activity notification
      elsif notification.trackable_type == "Order"
        order_activity notification
      elsif notification.trackable_type == "Schedule"
        schedule_activity notification
      end
      @notifications << @html
    end
    @notifications
  end

  private
  def product_activity notification
    @html = if notification.key == "product.create"
              ApplicationController.render locals: {activity: notification},
                partial: "public_activity/product/create"
            elsif notification.key == "product.update"
              ApplicationController.render locals: {activity: notification},
                partial: "public_activity/product/update"
            elsif notification.key == "request.create"
              ApplicationController.render locals: {activity: notification},
                partial: "public_activity/request/create"
            elsif notification.key == "request.update"
              ApplicationController.render locals: {activity: notification},
                partial: "public_activity/request/update"
            end
  end

  def order_activity notification
    @html = if notification.key == "order.processing"
              ApplicationController.render locals: {activity: notification},
                partial: "public_activity/order/processing"
            elsif notification.key == "order.completed"
              ApplicationController.render locals: {activity: notification},
                partial: "public_activity/order/completed"
            elsif notification.key == "order.canceled"
              ApplicationController.render locals: {activity: notification},
                partial: "public_activity/order/canceled"
            elsif notification.key == "order.create"
              ApplicationController.render locals: {activity: notification},
                partial: "public_activity/order/create"
            end
  end

  def schedule_activity notification
    @html = if notification.key == "schedule.on_schedule"
              ApplicationController.render locals: {activity: notification},
                partial: "public_activity/schedule/on_schedule"
            elsif notification.key == "schedule.off_schedule"
              ApplicationController.render locals: {activity: notification},
                partial: "public_activity/schedule/off_schedule"
            end
  end
end
