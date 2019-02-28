json.extract! booking, :id, :status, :title, :cost, :start_time, :end_time, :cancellation_reason, :refunded, :user_id, :schedule_id, :lesson_id, :created_at, :updated_at
json.url booking_url(booking, format: :json)
