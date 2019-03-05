class RemoveRefundFromBookings < ActiveRecord::Migration[5.2]
  def change
    remove_column :bookings, :refunded, :boolean
  end
end
