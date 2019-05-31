require "rufus-scheduler"

scheduler = Rufus::Scheduler.new

scheduler.every "1h" do
  Schedule.all.each do |s|
    @product_schedule = ProductSchedule.find_schedule s.id
    if s.activated == 0
      @product_schedule = ProductSchedule.find_schedule s.id
      scheduler.at s.start_time do
        @product_schedule.each do |p|
          Product.find_by(id: p.product_id).update_attributes discount: s.discount
        end
        create_notification Schedule.name, s, "schedule.on_schedule", User.admin.first
        s.update_attributes activated: 1
      end
    elsif s.activated == 1
      scheduler.at s.end_time do
        @product_schedule.each do |p|
          Product.find_by(id: p.product_id).update_attributes discount: 0
        end
        create_notification Schedule.name, s, "schedule.off_schedule", User.current_useradmin.first
        s.update_attributes activated: 2
      end
    end
  end
end

def create_notification model, object, key, recipient
  Notification.create! trackable_type: model, trackable_id: object.id,
    owner_type: nil, owner_id: nil, key: key,
    activity_type: Notification.activity_types[:notice],
    recipient_type: recipient.class, recipient_id: recipient.id
end
