class Lesson < ApplicationRecord
  has_and_belongs_to_many :instructors
end
