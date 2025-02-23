feature 'user authentication process' do
  scenario 'indicates that no user is logged in' do
    visit '/'
    expect(page).to have_content 'Who are you?'
  end

  scenario 'presents the option to login or sign up' do
    visit '/'
    click_on 'Login or sign up'
    expect(page).to have_content 'Login here'
    expect(page).to have_content 'Sign up below'
  end

  scenario 'allows a user with an existing account to sign in' do
    visit_root_and_sign_in

    expect(page).to have_content 'Signed in as mcquanzie'
  end

  scenario 'allows a user to create a new account' do
    random_username = "user-#{rand(100_000)}"
    random_password = "#{rand(3000..10_000)}HeLlO#{rand(5000)}"
    random_email = "user#{rand(100_000)}@example.com"

    visit '/'
    click_on 'Login or sign up'

    within '#new-user-form' do
      fill_in 'name', with: 'Viola Davis'
      fill_in 'username', with: random_username
      fill_in 'password', with: random_password
      fill_in 'email', with: random_email
      click_button 'sign up'
    end

    expect(page).to have_content "Signed in as #{random_username}"
  end
end
