require 'date'
require 'pry'

class Space < ActiveRecord::Base
  belongs_to :user
  has_many :reservations

  def dates
    from.step(to).map do |date|
      date.strftime('%d/%m/%Y')
    end
  end
end
