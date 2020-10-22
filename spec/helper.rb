def sign_in
  visit('/')
  fill_in :email, with: 'test@test.com'
  fill_in :password, with: '123'
  fill_in :password_confirmation, with: '123'
  click_button('submit')
  click_link('Log in')
  fill_in :email, with: 'test@test.com'
  fill_in :password, with: '123'
  click_button('log in')
end

def add_listing
  click_link('List a space')
  fill_in :name, with: 'home'
  fill_in :description, with: 'nice'
  fill_in :price, with: '10'
  fill_in :from, with: '01/12/2020'
  fill_in :to, with: '25/12/2020'
  click_button 'submit'
end

def sign_in_2
  visit('/')
  fill_in :email, with: 'guy@guy.com'
  fill_in :password, with: '234'
  fill_in :password_confirmation, with: '234'
  click_button('submit')
  click_link('Log in')
  fill_in :email, with: 'guy@guy.com'
  fill_in :password, with: '234'
  click_button('log in')
end
