class RemoveColumnsFromBookings < ActiveRecord::Migration[5.2]
  def change
    remove_column :bookings, :title, :string
    remove_column :bookings, :status, :string
    remove_column :bookings, :cost, :integer
    remove_column :bookings, :cancellation_reason, :text
  end
end
