require 'date'

class Reservation < ActiveRecord::Base
  belongs_to :space
  belongs_to :user

  def parsed_date
    date.strftime('%d/%m/%Y')
  end
end
