class Request < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :space
  belongs_to :user
end
