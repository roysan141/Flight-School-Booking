require "rails_helper"

RSpec.describe Instructor, :type => :model do
  subject { described_class.new }

  describe "#pseudo_availabilities" do
    context "with an availbility" do

      let(:start_time) { Time.new(2019, 1, 1, 9, 0, 0) }
      let(:end_time) { Time.new(2019, 1, 1, 17, 0, 0) }
      let!(:user) { User.create!(email:"email@example.com", password:"password", name:"Roysan") }
      let!(:plane) { Plane.create!(registration:"g-xxxx", typ:"kingair") }

      before do
        Availability.create({
          instructor:subject,
          start_time:start_time,
          end_time:end_time
        })
      end

      context "with no bookings" do
        it "returns the original availabilities" do
          expect(subject.pseudo_availabilities.length).to eql(1)
          expect(subject.pseudo_availabilities.first.start_time).to eql(start_time)
          expect(subject.pseudo_availabilities.first.end_time).to eql(end_time)
        end
      end

      context "with a single booking" do

        context "a booking that takes up the entire availability" do
          before do
            Booking.create!({
              instructor:subject,
              start_time:start_time,
              end_time:end_time,
              plane: plane,
              user: user
            })
          end

          it "returns a truncated availability" do
            expect(subject.pseudo_availabilities.length).to eql(0)
          end
        end


        context "at the end of the availability" do
          let(:booking_start_time) { Time.new(2019, 1, 1, 16, 0, 0) }
          before do
            Booking.create!({
              instructor:subject,
              start_time:booking_start_time,
              end_time:end_time,
              plane: plane,
              user: user
            })
          end

          it "returns a truncated availability" do
            expect(subject.pseudo_availabilities.length).to eql(1)
            expect(subject.pseudo_availabilities.first.start_time).to eql(start_time)
            expect(subject.pseudo_availabilities.first.end_time).to eql(booking_start_time)
          end
        end

        context "at the start of the availability" do
          let(:booking_end_time) { Time.new(2019, 1, 1, 10, 0, 0) }
          before do
            Booking.create!({
              instructor:subject,
              start_time:start_time,
              end_time:booking_end_time,
              plane: plane,
              user: user
            })
          end

          it "returns a truncated availability" do
            expect(subject.pseudo_availabilities.length).to eql(1)
            expect(subject.pseudo_availabilities.first.start_time).to eql(booking_end_time)
            expect(subject.pseudo_availabilities.first.end_time).to eql(end_time)
          end
        end

        context "in the middle of the availability" do
          let(:booking_start_time) { Time.new(2019, 1, 1, 11, 0, 0) }
          let(:booking_end_time) { Time.new(2019, 1, 1, 12, 0, 0)}

          before do
            Booking.create!({
              instructor:subject,
              start_time:booking_start_time,
              end_time:booking_end_time,
              plane: plane,
              user: user
            })
          end

          it "returns multiple availabilities" do
            expect(subject.pseudo_availabilities.length).to eql(2)
            expect(subject.pseudo_availabilities.first.start_time).to eql(start_time)
            expect(subject.pseudo_availabilities.first.end_time).to eql(booking_start_time)
            expect(subject.pseudo_availabilities.last.start_time).to eql(booking_end_time)
            expect(subject.pseudo_availabilities.last.end_time).to eql(end_time)
          end
        end

        context "with two bookings" do

          context "at the start and end of availability" do
            let(:first_booking_start_time) { Time.new(2019, 1, 1, 9, 0, 0) }
            let(:first_booking_end_time) { Time.new(2019, 1, 1, 10, 0, 0) }
            let(:second_booking_start_time) { Time.new(2019, 1, 1, 16, 0, 0) }
            let(:second_booking_end_time) { Time.new(2019, 1, 1, 17, 0, 0) }

            before do
              Booking.create!({
                instructor:subject,
                start_time:first_booking_start_time,
                end_time:first_booking_end_time,
                plane: plane,
                user: user
              })
              Booking.create!({
                instructor:subject,
                start_time:second_booking_start_time,
                end_time:second_booking_end_time,
                plane: plane,
                user: user
              })
            end

            it "returns a single availability" do
              expect(subject.pseudo_availabilities.length).to eql(1)
              expect(subject.pseudo_availabilities.first.start_time).to eql(first_booking_end_time)
              expect(subject.pseudo_availabilities.first.end_time).to eql(second_booking_start_time)
            end
          end

          context "two adjacent bookings in the middle" do
            let(:first_booking_start_time) { Time.new(2019, 1, 1, 11, 0, 0) }
            let(:first_booking_end_time) { Time.new(2019, 1, 1, 12, 0, 0) }
            let(:second_booking_start_time) { Time.new(2019, 1, 1, 12, 0, 0) }
            let(:second_booking_end_time) { Time.new(2019, 1, 1, 13, 0, 0) }

            before do
              Booking.create!({
                instructor:subject,
                start_time:first_booking_start_time,
                end_time:first_booking_end_time,
                plane: plane,
                user: user
              })
              Booking.create!({
                instructor:subject,
                start_time:second_booking_start_time,
                end_time:second_booking_end_time,
                plane: plane,
                user: user
              })
            end

            it "returns two availabilities" do
              expect(subject.pseudo_availabilities.length).to eql(2)
              expect(subject.pseudo_availabilities.first.start_time).to eql(start_time)
              expect(subject.pseudo_availabilities.first.end_time).to eql(first_booking_start_time)
              expect(subject.pseudo_availabilities.second.start_time).to eql(second_booking_end_time)
              expect(subject.pseudo_availabilities.second.end_time).to eql(end_time)
            end
          end

          context "with three or more bookings" do
            context "at start, end, and two in middle of availability" do
              let(:first_booking_start_time) { Time.new(2019, 1, 1, 9, 0, 0) }
              let(:first_booking_end_time) { Time.new(2019, 1, 1, 10, 0, 0) }
              let(:second_booking_start_time) { Time.new(2019, 1, 1, 11, 0, 0) }
              let(:second_booking_end_time) { Time.new(2019, 1, 1, 12, 0, 0) }
              let(:third_booking_start_time) { Time.new(2019, 1, 1, 14, 0, 0) }
              let(:third_booking_end_time) { Time.new(2019, 1, 1, 15, 0, 0) }
              let(:fourth_booking_start_time) { Time.new(2019, 1, 1, 16, 0, 0) }
              let(:fourth_booking_end_time) { Time.new(2019, 1, 1, 17, 0, 0) }

              before do
                Booking.create!({
                  instructor:subject,
                  start_time:first_booking_start_time,
                  end_time:first_booking_end_time,
                  plane: plane,
                  user: user
                })
                Booking.create!({
                  instructor:subject,
                  start_time:second_booking_start_time,
                  end_time:second_booking_end_time,
                  plane: plane,
                  user: user
                })
                Booking.create!({
                  instructor:subject,
                  start_time:third_booking_start_time,
                  end_time:third_booking_end_time,
                  plane: plane,
                  user: user
                })
                Booking.create!({
                  instructor:subject,
                  start_time:fourth_booking_start_time,
                  end_time:fourth_booking_end_time,
                  plane: plane,
                  user: user
                })
              end

              it "returns three availabilities" do
                expect(subject.pseudo_availabilities.length).to eql(3)
                expect(subject.pseudo_availabilities.first.start_time).to eql(first_booking_end_time)
                expect(subject.pseudo_availabilities.first.end_time).to eql(second_booking_start_time)
                expect(subject.pseudo_availabilities.second.start_time).to eql(second_booking_end_time)
                expect(subject.pseudo_availabilities.second.end_time).to eql(third_booking_start_time)
                expect(subject.pseudo_availabilities.third.start_time).to eql(third_booking_end_time)
                expect(subject.pseudo_availabilities.third.end_time).to eql(fourth_booking_start_time)
              end
            end
          end
        end
      end
    end
  end
end
