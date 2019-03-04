class CreateJoinTableInstructorLesson < ActiveRecord::Migration[5.2]
  def change
    create_join_table :instructors, :lessons do |t|
      # t.index [:instructor_id, :lesson_id]
      # t.index [:lesson_id, :instructor_id]
    end
  end
end
