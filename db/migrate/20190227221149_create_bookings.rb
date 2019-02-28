class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.string :status
      t.string :title
      t.integer :cost
      t.datetime :start_time
      t.datetime :end_time
      t.text :cancellation_reason
      t.boolean :refunded
      t.integer :user_id
      t.integer :schedule_id
      t.integer :lesson_id

      t.timestamps
    end
    add_index :bookings, :user_id
    add_index :bookings, :schedule_id
    add_index :bookings, :lesson_id
  end
end
