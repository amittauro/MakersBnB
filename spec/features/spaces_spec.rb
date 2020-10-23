feature 'spaces' do
  scenario 'i can submit a space to MakersAirBnB' do
    sign_in
    add_listing
    expect(page).to have_content('home')
    expect(current_path).to eq('/spaces')
  end

  scenario 'I can book a date for one night' do
    sign_in
    add_listing
    first('.space').click_button('book')
    expect(page).to have_content('Dates')
  end

  # scenario 'I can book a space for night' do
  #   sign_in
  #   add_listing
  #   first('.space').click_button('book')
  #   expect(page).to have_content('Dates')
  #   first('.date').click_button('book')
  #   expect(current_path).to eq('/requests/01/12/2020')
  # end

  scenario 'I can make a request for a place and view that request' do
    sign_in
    add_listing
    first('.space').click_button('book')
    expect(page).to have_content('Dates')
    first('.date').click_button('book')
    expect(page).to have_content('home')
    expect(current_path).to eq('/requests')
  end

  scenario 'I can approve a request made by someone' do
    sign_in
    add_listing
    click_button('log out')
    sign_in_2
    first('.space').click_button('book')
    first('.date').click_button('book')
    click_button('log out')
    click_link('Log in')
    fill_in :email, with: 'test@test.com'
    fill_in :password, with: '123'
    click_button('log in')
    click_link('Requests')
    first('.request').click_button('approve')
    p page.body
    click_button('log out')
    click_link('Log in')
    fill_in :email, with: 'guy@guy.com'
    fill_in :password, with: '234'
    click_button('log in')
    first('.space').click_button('book')
    expect(page).to have_no_content('01/12/2020')
  end

  scenario 'I can deny a request made by someone' do
    sign_in
    add_listing
    click_button('log out')
    sign_in_2
    first('.space').click_button('book')
    first('.date').click_button('book')
    click_button('log out')
    click_link('Log in')
    fill_in :email, with: 'test@test.com'
    fill_in :password, with: '123'
    click_button('log in')
    click_link('Requests')
    first('.request').click_button('deny')
    click_button('log out')
    click_link('Log in')
    fill_in :email, with: 'guy@guy.com'
    fill_in :password, with: '234'
    click_button('log in')
    first('.space').click_button('book')
    expect(page).to have_content('01/12/2020')
  end

  scenario 'My request no longer exists when approved' do
    sign_in
    add_listing
    click_button('log out')
    sign_in_2
    first('.space').click_button('book')
    first('.date').click_button('book')
    click_button('log out')
    click_link('Log in')
    fill_in :email, with: 'test@test.com'
    fill_in :password, with: '123'
    click_button('log in')
    click_link('Requests')
    first('.request').click_button('deny')
    expect(page).to have_no_content('home')
    expect(page).to have_no_content('nice')
    p page.body
  end

end


#request(user_id, space_id )
