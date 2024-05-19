require_relative '../../app/models/schedule'
require_relative '../../app/models/appointment'

RSpec.describe Schedule do
  let(:schedule) { Schedule.new }
  let(:start_time) { Time.new(2024, 5, 20, 10, 0, 0) }
  let(:appointment) { Appointment.new(:standard, start_time) }

  describe '#book' do
    it 'books an appointment' do
      schedule.book(appointment)
      expect(schedule.appointments_on(start_time.to_date)).to include(appointment)
    end
  end

  describe '#appointments_on' do
    let(:another_start_time) { Time.new(2024, 5, 20, 9, 0, 0) }
    let(:another_appointment) { Appointment.new(:check_in, another_start_time) }

    before do
      schedule.book(appointment)
      schedule.book(another_appointment)
    end

    it 'returns appointments on a specific date' do
      expect(schedule.appointments_on(start_time.to_date)).to contain_exactly(appointment, another_appointment)
    end

    it 'returns appointments sorted by start_time' do
      expect(schedule.appointments_on(start_time.to_date)).to eq([another_appointment, appointment])
    end

    it 'returns an empty array if no appointments on the date' do
      expect(schedule.appointments_on(Date.new(2024, 5, 2))).to be_empty
    end
  end
end
