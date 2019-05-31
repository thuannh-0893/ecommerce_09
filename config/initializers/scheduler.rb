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
        puts "Khuyen mai toi!!!!"
        s.update_attributes activated: 1
      end
    elsif s.activated == 1
      scheduler.at s.end_time do
        @product_schedule.each do |p|
          Product.find_by(id: p.product_id).update_attributes discount: 0
        end
        puts "Khuyen mai di!!!!"
        s.update_attributes activated: 2
      end
    end
  end
end
