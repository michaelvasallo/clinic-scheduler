require_relative '../models/appointment'

class AvailabilityService
  CLINIC_OPEN_HOUR = 9
  CLINIC_CLOSE_HOUR = 17
  SLOT_DURATION_SECONDS = 30 * 60
  BOOKING_CUTOFF_SECONDS = 120 * 60

  def initialize(schedule, type, date)
    @appointment_duration = Appointment::DURATIONS[type]
    @current_slot = [clinic_opening_time(date), next_bookable_slot].max
    @end_time = clinic_closing_time(date)
    @booked_appointments = schedule.appointments_on(date)
    @booked_index = find_starting_index
  end

  def call
    available_slots = []

    while slot_within_clinic_hours?
      if overlaps_with_booked_appointment?
        advance_to_next_slot_after_booked_appointment
      else
        available_slots << @current_slot
        advance_to_next_slot
      end
    end

    available_slots
  end

  private

  def clinic_opening_time(date)
    Time.new(date.year, date.month, date.day, CLINIC_OPEN_HOUR, 0, 0)
  end

  def clinic_closing_time(date)
    Time.new(date.year, date.month, date.day, CLINIC_CLOSE_HOUR, 0, 0)
  end

  def next_bookable_slot
    Time.at((Time.now + BOOKING_CUTOFF_SECONDS + SLOT_DURATION_SECONDS).to_i / SLOT_DURATION_SECONDS * SLOT_DURATION_SECONDS)
  end

  def find_starting_index
    @booked_appointments.bsearch_index { |appt| appt.end_time > @current_slot } || @booked_appointments.size
  end

  def overlaps_with_booked_appointment?
    @booked_index < @booked_appointments.size &&
      @current_slot + @appointment_duration > @booked_appointments[@booked_index].start_time
  end

  def slot_within_clinic_hours?
    @current_slot + @appointment_duration <= @end_time
  end

  def advance_to_next_slot_after_booked_appointment
    @current_slot = @booked_appointments[@booked_index].end_time
    @booked_index += 1
  end

  def advance_to_next_slot
    @current_slot += SLOT_DURATION_SECONDS
  end
end
