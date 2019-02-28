require "application_system_test_case"

class BookingsTest < ApplicationSystemTestCase
  setup do
    @booking = bookings(:one)
  end

  test "visiting the index" do
    visit bookings_url
    assert_selector "h1", text: "Bookings"
  end

  test "creating a Booking" do
    visit bookings_url
    click_on "New Booking"

    fill_in "Cancellation reason", with: @booking.cancellation_reason
    fill_in "Cost", with: @booking.cost
    fill_in "End time", with: @booking.end_time
    fill_in "Lesson", with: @booking.lesson_id
    fill_in "Refunded", with: @booking.refunded
    fill_in "Schedule", with: @booking.schedule_id
    fill_in "Start time", with: @booking.start_time
    fill_in "Status", with: @booking.status
    fill_in "Title", with: @booking.title
    fill_in "User", with: @booking.user_id
    click_on "Create Booking"

    assert_text "Booking was successfully created"
    click_on "Back"
  end

  test "updating a Booking" do
    visit bookings_url
    click_on "Edit", match: :first

    fill_in "Cancellation reason", with: @booking.cancellation_reason
    fill_in "Cost", with: @booking.cost
    fill_in "End time", with: @booking.end_time
    fill_in "Lesson", with: @booking.lesson_id
    fill_in "Refunded", with: @booking.refunded
    fill_in "Schedule", with: @booking.schedule_id
    fill_in "Start time", with: @booking.start_time
    fill_in "Status", with: @booking.status
    fill_in "Title", with: @booking.title
    fill_in "User", with: @booking.user_id
    click_on "Update Booking"

    assert_text "Booking was successfully updated"
    click_on "Back"
  end

  test "destroying a Booking" do
    visit bookings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Booking was successfully destroyed"
  end
end
