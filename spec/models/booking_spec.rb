require "rails_helper"

RSpec.describe Booking, :type => :model do

  let!(:user) { User.create!(email:"email@example.com", password:"password", name:"Roysan") }
  let!(:plane) { Plane.create!(registration:"g-xxxx", typ:"kingair") }
  let!(:instructor) { Instructor.create!(name:"Will Flanagan", email:"email@instructor.com") }
  let!(:availability) do
    Availability.create!(
      instructor: instructor,
      start_time: Time.new(2019, 1, 1, 8, 0, 0),
      end_time: Time.new(2019, 1, 1, 20, 0, 0)
    )
  end

  subject do
    described_class.new({
      user: user,
      instructor: instructor,
      plane: plane,
      start_time: Time.new(2019, 1, 1, 9, 0, 0),
      end_time: Time.new(2019, 1, 1, 10, 0, 0)
    })
  end

  context "with no other bookings" do
    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "with an existing booking for the plane" do

    context "that does not overlap" do
      before do
        described_class.create!({
          user: user,
          instructor: instructor,
          plane: plane,
          start_time: Time.new(2019, 1, 1, 11, 0, 0),
          end_time: Time.new(2019, 1, 1, 12, 0, 0)
        })
      end

      it "is valid" do
        expect(subject).to be_valid
      end
    end

    context "that is adjacent" do
      before do
        described_class.create!({
          user: user,
          instructor: instructor,
          plane: plane,
          start_time: Time.new(2019, 1, 1, 10, 0, 0),
          end_time: Time.new(2019, 1, 1, 11, 0, 0)
        })
      end

      it "is valid" do
        expect(subject).to be_valid
      end
    end

    context "that overlaps" do
      before do
        described_class.create!({
          user: user,
          instructor: instructor,
          plane: plane,
          start_time: Time.new(2019, 1, 1, 9, 0, 0),
          end_time: Time.new(2019, 1, 1, 10, 0, 0)
        })
      end

      it "is not valid" do
        expect(subject).to_not be_valid
      end
    end
  end
end
