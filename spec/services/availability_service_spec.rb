require_relative '../../app/models/appointment'
require_relative '../../app/models/schedule'
require_relative '../../app/services/availability_service'
require 'timecop'

RSpec.describe AvailabilityService do
  subject(:service) { AvailabilityService.new(schedule, :standard, Date.new(2024, 5, 20)) }
  let(:schedule) { Schedule.new }
  let(:current_time) { Time.new(2024, 5, 19, 14, 0, 0) }

  before { Timecop.freeze(current_time) }
  after { Timecop.return }

  describe '#call' do
    let(:available_slots) { service.call }

    context 'when there are no booked appointments' do
      it 'returns all available slots within clinic hours' do
        expect(available_slots.size).to eq 15
        expect(available_slots.first).to eq Time.new(2024, 5, 20, 9, 0, 0)
        expect(available_slots.last).to eq Time.new(2024, 5, 20, 16, 0, 0)
      end
    end

    context 'when there are booked appointments' do
      let(:expected_slots) do
        [
          Time.new(2024, 5, 20, 9, 0, 0),
          Time.new(2024, 5, 20, 10, 30, 0),
          Time.new(2024, 5, 20, 13, 0, 0)
        ]
      end

      before do
        schedule.book(Appointment.new(:check_in, Time.new(2024, 5, 20, 10, 0, 0)))
        schedule.book(Appointment.new(:initial_consultation, Time.new(2024, 5, 20, 11, 30, 0)))
      end

      it 'returns available slots that do not overlap with booked appointments' do
        expect(available_slots.first(3)).to eq(expected_slots)
      end
    end

    context 'when the booking cutoff time applies' do
      let(:current_time) { Time.new(2024, 5, 20, 9, 15, 0) }
      let(:cutoff_start_time) { Time.new(2024, 5, 20, 11, 30, 0) }

      it 'excludes slots within the booking cutoff time' do
        expect(available_slots.first).to eq(cutoff_start_time)
      end

      context 'and there are appointments that end before the cutoff time' do
        before { schedule.book(Appointment.new(:check_in, Time.new(2024, 5, 20, 9, 0, 0))) }

        it 'ignores them and returns the correct slots' do
          expect(available_slots.first).to eq(cutoff_start_time)
        end
      end
    end
  end
end
