class AddEmailsToInstructors < ActiveRecord::Migration[5.2]
  def change
    add_column :instructors, :email, :string
  end
end
