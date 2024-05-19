require_relative '../../app/models/appointment'

RSpec.describe Appointment do
  describe '#initialize' do
    subject(:appointment) { Appointment.new(:standard, start_time) }
    let(:start_time) { Time.new(2024, 5, 20, 10, 0, 0) }

    it 'initializes with the correct type, start time, and end time' do
      expect(appointment.type).to eq(:standard)
      expect(appointment.start_time).to eq(start_time)
      expect(appointment.end_time).to eq(start_time + 60 * 60)
    end
  end
end
