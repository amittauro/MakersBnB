require './app/models/space'
require 'date'

describe Space do
  describe '.dates' do
    it 'returns an array of dates in string format' do
      space = Space.create(name: 'home', description: 'nice',
        price: '15', from: Date.parse('01/12/2020'), to: Date.parse('03/12/2020'))
      expect(space.dates).to eq(['01/12/2020','02/12/2020','03/12/2020'])
    end
  end
end
