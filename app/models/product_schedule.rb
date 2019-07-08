class ProductSchedule < ApplicationRecord
  belongs_to :product
  belongs_to :schedule
  delegate :name, :price, to: :product, prefix: true

  scope :find_schedule, ->(schedule_id){where schedule_id: schedule_id}
end
