
class ManageSlotsJob < ApplicationJob
    queue_as :default
  
    def perform
      Slot.expired.destroy_all
  
      Field.find_each do |field|
        next_day = Time.now.to_date + 1
        next if field.exclude_days.include?(next_day.wday)
  
        Slot.generate_slots(field)
      end
    end
  end
  