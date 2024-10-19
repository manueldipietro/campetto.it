class Slot < ApplicationRecord
  belongs_to :field
  has_one :booking

  scope :expired, -> { where('end_time < ?', Time.now) }

  def self.generate_slots(field)
    start_time = field.start_time
    end_time = field.end_time
    interval = field.interval.minutes
    exclude_days = field.exclude_days.split(',').map(&:to_i)
  
  
    (1..(6.months / 1.day)).each do |day_offset|
      next_day = Date.today + day_offset
  
      next if exclude_days.include?(next_day.wday)
  
      current_time = Time.new(next_day.year, next_day.month, next_day.day, start_time.hour, start_time.min)
  
      while current_time + interval <= Time.new(next_day.year, next_day.month, next_day.day, end_time.hour, end_time.min)
        Slot.create!(
          field: field,
          start_time: current_time,
          end_time: current_time + interval,
          booked: false
        )
  
        current_time += interval
      end
    end
  end  
end
