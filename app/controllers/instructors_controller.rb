class InstructorsController < ApplicationController
  before_action :set_instructor, only: [:show, :edit, :update, :destroy]

  # GET /bookings
  # GET /bookings.json
  def index
    @instructors = Instructor.all
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_instructor
    @instructor = Instructor.find(params[:id])
  end
end
