require_relative '../app/models/appointment'
require_relative '../app/models/schedule'
require_relative '../app/services/availability_service'
require_relative '../app/app'
require 'timecop'

RSpec.describe App do
  let(:app) { App.new }
  let(:start_time) { Time.new(2024, 5, 20, 10, 0, 0) }
  let(:current_time) { Time.new(2024, 5, 20, 6, 0, 0) }
  let(:available_slots) { [start_time] }
  let(:availability_service) { instance_double(AvailabilityService) }
  let(:schedule) { instance_double(Schedule) }

  before do
    Timecop.freeze(current_time)
    allow(Schedule).to receive(:new).and_return(schedule)
    allow(AvailabilityService).to receive(:new).and_return(availability_service)
    allow(availability_service).to receive(:call).and_return(available_slots)
  end

  after { Timecop.return }

  describe '#available_times' do
    it 'returns available time slots from the availability service' do
      expect(app.available_times(:standard, Date.today)).to eq(available_slots)
    end
  end

  describe '#book_appointment' do
    context 'when the slot is available' do
      it 'books the appointment and returns true' do
        expect(schedule).to receive(:book).with(instance_of(Appointment))
        expect(app.book_appointment(:standard, start_time)).to eq(true)
      end
    end

    context 'when the slot is not available' do
      let(:available_slots) { [] }

      it 'does not book the appointment and returns false' do
        expect(schedule).not_to receive(:book)
        expect(app.book_appointment(:standard, start_time)).to eq(false)
      end
    end
  end

  describe '#todays_appointments' do
    let(:appointments) { [Appointment.new(:standard, start_time)] }

    before { allow(schedule).to receive(:appointments_on).with(Date.today).and_return(appointments) }

    it 'returns the appointments for today' do
      expect(app.todays_appointments).to eq(appointments)
    end
  end
end
