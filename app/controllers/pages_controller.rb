class PagesController < ApplicationController
  def home
    @bookings = Booking.all
  end

  def index
    @bookings = current_user.bookings.all
  end

  def availability
    @availabilities = Availability.all
  end
end
