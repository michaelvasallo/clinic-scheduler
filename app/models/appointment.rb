class Appointment
  attr_reader :type, :start_time, :end_time

  DURATIONS = {
    initial_consultation: 90 * 60,
    standard: 60 * 60,
    check_in: 30 * 60
  }.freeze

  def initialize(type, start_time)
    @type = type
    @start_time = start_time
    @end_time = start_time + DURATIONS[type]
  end
end
