class CreateAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :availabilities do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :instructor, foreign_key: true

      t.timestamps
    end
  end
end
