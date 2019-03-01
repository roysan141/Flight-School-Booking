class Booking < ApplicationRecord
  belongs_to :plane
  belongs_to :user

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :user_id, presence: true
  validates :plane_id, presence: true

  def end_must_be_after_start
    if start_time >= end_time
    errors.add(:end_time, "must be after start time")
    end
  end

  validate :booking_must_not_overlap_scoped_by_plane
  validate :booking_must_not_overlap_scoped_by_user

  private
  def booking_must_not_overlap_scoped_by_plane
    return if self
                .class
                .where.not(id: id)
                .where(plane_id: plane_id)
                .where('start_time < ? AND end_time > ?', end_time, start_time)
                .none?
    errors.add(:base, 'Error, Plane unavailable at this time')

  end

  def booking_must_not_overlap_scoped_by_user
    return if self
                .class
                .where.not(id: id)
                .where(user_id: user_id)
                .where('start_time < ? AND end_time > ?', end_time, start_time)
                .none?
    errors.add(:base, 'ERROR, User unavailable at this time')
  end


end
