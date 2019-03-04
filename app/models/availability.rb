class Availability < ApplicationRecord
  belongs_to :instructor

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :availability_must_not_overlap_scoped_by_instructor
  validate :end_must_be_after_start

  private

  def availability_must_not_overlap_scoped_by_instructor
    return if self
                .class
                .where.not(id: id)
                .where(instructor_id: instructor_id)
                .where('start_time < ? AND end_time > ?', end_time, start_time)
                .none?
    errors.add(:base, 'Error, instructor unavailable at this time')
  end

  def end_must_be_after_start
    if start_time > end_time
    errors.add(:end_time, "must be after start time")
    end
  end

end
