require 'date'

class Reservation < ActiveRecord::Base
  belongs_to :space
  belongs_to :user
  has_many :requests

  def parsed_date
    date.strftime('%d/%m/%Y')
  end

  def self.create_range(from:, to:, space_id:)
    Date.parse(from).step(Date.parse(to)).map do |date|
      self.create(date: date, booked: false, space_id: space_id)
    end
  end
end
