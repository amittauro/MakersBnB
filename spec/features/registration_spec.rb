feature 'Registration' do
  scenario 'a user can sign up' do
    visit('/')
    fill_in :email, with: 'test@test.com'
    fill_in :password, with: '123'
    fill_in :password_confirmation, with: '123'
    click_button('submit')
    expect(page).to have_content('Email')
  end

  scenario 'flashes an error message if password and password_confirmation dont match' do
    visit('/')
    fill_in :email, with: 'test@test.com'
    fill_in :password, with: '123'
    fill_in :password_confirmation, with: '125'
    click_button('submit')
    expect(page).to have_content("password and password_confirmation don't match")
  end

  # scenario 'user can log in' do
  #   sign_in
  #   expect(page).to have_content('Hi test@test.com')
  # end

  scenario 'user can log out' do
    sign_in
    click_button('log out')
    expect(current_path).to eq('/')
  end
end
