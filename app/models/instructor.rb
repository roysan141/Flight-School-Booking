class Instructor < ApplicationRecord
  has_and_belongs_to_many :lessons
  has_many :availabilities

  def pseudo_availabilities
    p = []

    availibilities.each do |a|
      conflicting_bookings = bookings.where('end_time <= ? AND end_time >= ?', end_time, start_time).to_a
      p << a && next if conflicting_bookings.empty?

      current = a.start_time

      conflicting_bookings.each_with_index do |b, i|
        if b.end_time <= a.end_time && b.end_time >= a.start_time

          #if booking starts at or before official availability
          if b.start_time > a.start_time
            current = b.end_time
            p << Availability.new(instructor:self, start_time:a.start_time, end_time: b.start_time)
            next
          end

          #if booking intersects official availbility
          if b.start_time > a.start_time && b.end_time < a.end_time
            current = conflicting_bookings[i+1].end_time unless i == (conflicting_bookings.length - 1)
            p << Availability.new(instructor:self, start_time:current, end_time: bz[i+1].start_time)
            next
          end

          #if booking ends at the end of or after official availability
          if b.end_time >= a.end_time 
            p << Availability.new(instructor:self, start_time:current, end_time: b.start_time)
          end
        end
      end
    end

    p
  end
end
