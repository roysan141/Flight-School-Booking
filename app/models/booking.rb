class Booking < ApplicationRecord
  belongs_to :plane
  belongs_to :user
  belongs_to :instructor, optional: true

  paginates_per 5

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :user_id, presence: true
  validates :plane_id, presence: true
  validate :booking_must_not_overlap_scoped_by_plane
  validate :booking_must_not_overlap_scoped_by_user
  validate :instructor_must_be_available
  validate :booking_must_not_overlap_scoped_by_instructor
  validate :end_must_be_after_start

  #after_create :send_booking_request_email
  #after_save :send_booking_confirmed_email, if: :saved_change_to_confirmed?


  def calendar_time(key, date)
    t = send(key.to_sym)
    if t.to_date == date.to_date
      return t.to_s(:time)
    end
    return t.strftime("%a %b #{t.day.ordinalize}")
  end

  def send_booking_request_email
    if instructor.present?
      UserMailer.with(booking: self).booking_request.deliver_now!
    end
  end

  def send_booking_confirmed_email
    if confirmed
      UserMailer.with(booking: self).booking_confirmed.deliver_now!
    end
  end

  private

  def booking_must_not_overlap_scoped_by_plane
    return if self
                .class
                .where.not(id: id)
                .where(plane_id: plane_id)
                .where('start_time < ? AND end_time > ?', end_time, start_time)
                .none?
    errors.add(:base, 'Error, aircraft unavailable at this time')

  end

  def booking_must_not_overlap_scoped_by_user
    return if self
                .class
                .where.not(id: id)
                .where(user_id: user_id)
                .where('start_time < ? AND end_time > ?', end_time, start_time)
                .none?
    errors.add(:base, 'ERROR, user unavailable at this time')
  end

  def booking_must_not_overlap_scoped_by_instructor
    return unless instructor_id.present?
    return if self
                .class
                .where.not(id: id)
                .where(instructor_id: instructor_id)
                .where('start_time < ? AND end_time > ?', end_time, start_time)
                .none?
    errors.add(:base, 'Error, instructor unavailable at this time')
  end

  def instructor_must_be_available
    return unless instructor_id.present?
    return if instructor.availabilities.
      where('start_time <= ? AND end_time >= ?', start_time, end_time).first.present?
    errors.add(:base, 'Error, instructor unavailable at this time')
  end

  def end_must_be_after_start
    if start_time > end_time
    errors.add(:end_time, "must be after start time")
    end
  end
end
