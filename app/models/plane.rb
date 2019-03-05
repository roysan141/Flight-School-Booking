class Plane < ApplicationRecord
  has_many :bookings
  def name
    return "#{registration} (#{typ})"
  end
end
