class AddInstructorToBookings < ActiveRecord::Migration[5.2]
  def change
    add_reference :bookings, :instructor, foreign_key: true
  end
end
