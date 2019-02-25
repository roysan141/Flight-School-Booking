class AddIsTrainerToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_trainer, :boolean
  end
end
