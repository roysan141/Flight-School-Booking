class PagesController < ApplicationController
  def home
    @bookings = Booking.all
  end

  def index
    @bookings = current_user.bookings.all
  end
end
