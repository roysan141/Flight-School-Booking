class CreatePlanes < ActiveRecord::Migration[5.2]
  def change
    create_table :planes do |t|
      t.string :registration
      t.string :typ

      t.timestamps
    end
  end
end
