class Notification < PublicActivity::Activity
  include ApplicationHelper
  # belongs_to :user
  # belongs_to :recipient, class_name: "User"
  enum activity_types: {danger: 0, notice: 1}
  after_create :send_notification
  scope :unread, ->{where read: 0}
  scope :by_updated, ->{order updated_at: :desc}
  scope :correct_user, ->(id){where recipient_id: id}

  def send_notification
    count = Notification.correct_user(recipient_id).unread.count
    NotificationBroadcastJob.perform_now count, self
  end
end
