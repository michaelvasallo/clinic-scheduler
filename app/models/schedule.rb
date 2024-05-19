class Schedule
  def initialize
    @appointments = Hash.new { |hash, key| hash[key] = [] }
  end

  def book(appointment)
    @appointments[appointment.start_time.to_date.to_s] << appointment
  end

  def appointments_on(date)
    @appointments[date.to_s].sort_by(&:start_time)
  end
end
