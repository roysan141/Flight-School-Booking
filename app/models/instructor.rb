class Instructor < ApplicationRecord
  has_and_belongs_to_many :lessons
  has_many :availabilities
end
