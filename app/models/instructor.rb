class Instructor < ApplicationRecord
  has_and_belongs_to_many :lessons
  has_many :availabilities
  has_many :bookings


  def pseudo_availabilities
    p = []
    availabilities.each do |a|
      conflicting_bookings = bookings.where('end_time <= ? AND end_time >= ?', a.end_time, a.start_time).to_a
      p << a && next if conflicting_bookings.empty?
      cursor = a.start_time

      conflicting_bookings.each do |b|
        if b.start_time > a.start_time
          p << Availability.new(
            instructor:self,
            start_time:cursor,
            end_time: b.start_time
          )
        end
        cursor = b.end_time
      end

      if cursor < a.end_time
        p << Availability.new(
          instructor:self,
          start_time:cursor,
          end_time: a.end_time
        )
      end
    end
    p.delete_if { |a| 30.minutes > (a.end_time - a.start_time) }
  end
end
