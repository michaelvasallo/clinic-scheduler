require_relative 'models/appointment'
require_relative 'models/schedule'
require_relative 'services/availability_service'

class App
  def initialize
    @schedule = Schedule.new
  end

  def available_times(type, date)
    AvailabilityService.new(@schedule, type, date).call
  end

  def book_appointment(type, start_time)
    return false unless available_times(type, start_time.to_date).include?(start_time)

    @schedule.book(Appointment.new(type, start_time))
    true
  end

  def todays_appointments
    @schedule.appointments_on(Date.today)
  end
end
