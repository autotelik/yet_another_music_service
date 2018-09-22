# frozen_string_literal: true

Warden.test_mode!

feature 'User profile page', :devise do
  let(:me) { FactoryBot.create(:user, :with_avatar) }

  before do
    login_as(me, scope: :user)
  end

  after(:each) do
    Warden.test_reset!
  end
  # Scenario: User sees own profile
  #   Given I am signed in
  #   When I visit the users profile page
  #   Then I see my own email address
  scenario 'users sees own profile' do
    visit user_path(me)
    expect(page).to have_content me.name
    expect(page).to have_content me.email
    expect(find(:xpath, "//img[@class='avatar avatar-lg']")['src']).to match /test_image\.jpg/
  end

  scenario 'users has ability to edit own profile' do
    visit user_path(me)
    expect(page).to have_css 'a.icon_tag'
  end

  # Scenario: User can see another users's profile but cannot edit
  #   Given I am signed in
  #   When I visit another users's profile
  #   Then I see their details but no edit button
  scenario "users cannot see another users's profile" do
    other = FactoryBot.create(:user, email: 'other@example.com')
    Capybara.current_session.driver.header 'Referer', root_path
    visit user_path(other)
    expect(page).to_not have_css 'a.icon_tag'
  end
end
