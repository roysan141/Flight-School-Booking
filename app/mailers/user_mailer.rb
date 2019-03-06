class UserMailer < ApplicationMailer
  def booking_request
    @booking = params[:booking]
    @url = edit_admin_booking_url(@booking)
    mail(to: @booking.instructor.email, subject: 'New booking request')
  end
  def booking_confirmed
    @booking = params[:booking]
    @url = bookings_url
    mail(to: @booking.user.email, subject: 'Booking confirmed')
  end
end
