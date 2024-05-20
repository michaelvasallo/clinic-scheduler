require_relative '../models/appointment'

class AvailabilityService
  CLINIC_OPEN = 9
  CLINIC_CLOSE = 17
  SLOT_GAP = 30 * 60
  BOOKING_CUTOFF_TIME = 120 * 60

  def initialize(schedule, type, date)
    @appointment_duration = Appointment::DURATIONS[type]
    @current_slot = [Time.new(date.year, date.month, date.day, CLINIC_OPEN, 0, 0), next_possible_slot].max
    @end_time = Time.new(date.year, date.month, date.day, CLINIC_CLOSE, 0, 0)
    @booked_appointments = schedule.appointments_on(date)
    @booked_index = find_starting_index
  end

  def call
    available_slots = []

    while @current_slot + @appointment_duration <= @end_time
      if overlaps_with_booked_appointment?
        @current_slot = @booked_appointments[@booked_index].end_time
        @booked_index += 1
      else
        available_slots << @current_slot
        @current_slot += SLOT_GAP
      end
    end

    available_slots
  end

  private

  def find_starting_index
    @booked_appointments.bsearch_index { |appt| appt.end_time > @current_slot } || @booked_appointments.size
  end

  def overlaps_with_booked_appointment?
    @booked_index < @booked_appointments.size &&
      @current_slot + @appointment_duration > @booked_appointments[@booked_index].start_time
  end

  def next_possible_slot
    Time.at((Time.now + BOOKING_CUTOFF_TIME + SLOT_GAP).to_i / SLOT_GAP * SLOT_GAP)
  end
end
