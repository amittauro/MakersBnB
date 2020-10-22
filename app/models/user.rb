require 'bcrypt'

class User < ActiveRecord::Base
  has_many :spaces
  # users.password_hash in the database is a :string
  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.create(email:, password:, password_confirmation:)
    user = User.new(email: email)
    user.password = password
    user.save!
  end

  def self.login(email:, password:)
    user = User.find_by_email(email)
    user.password == password
  end
end
