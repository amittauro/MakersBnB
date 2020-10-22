describe User do
  describe '.create' do
    it 'returns a user object' do
      User.create(email: 'test@test.com', password: 'yes', password_confirmation: 'yes')
      user = User.find_by(email: 'test@test.com')
      expect(user.email).to eq('test@test.com')
    end
  end

  describe '.login' do
    it 'returns true if user can log in' do
      User.create(email: 'test@test.com', password: 'yes', password_confirmation: 'yes')
      expect(User.login(email: 'test@test.com', password: 'yes')).to eq(true)
    end
  end
end
