class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.datetime :start
      t.datetime :end
      t.integer :user_id

      t.timestamps
    end
    add_index :schedules, :user_id
  end
end
