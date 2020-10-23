require './app/models/reservation'

describe Reservation do
  describe 'create_range' do
    it 'returns an array of instances of Reservation' do
      reservations = Reservation.create_range(from: '01/01/2021', to: '20/01/2010', space_id: '1')
      expect(reservations).to all(be_an_instance_of(Reservation))
    end
  end
end
