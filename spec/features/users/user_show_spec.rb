# frozen_string_literal: true

Warden.test_mode!

feature 'User profile page', :devise do
  let(:me) { FactoryBot.create(:user, :with_avatar) }

  before do
    login_as(me, scope: :user)

    allow_any_instance_of(ApplicationController).to receive(:current_user) { me }
  end

  after(:each) do
    Warden.test_reset!
  end
  # Scenario: User sees own profile
  #   Given I am signed in
  #   When I visit the users profile page
  #   Then I see my own email address
  scenario 'users sees own profile' do
    visit yams_core.user_path(me)
    expect(page).to have_content me.name
    expect(page).to have_content me.email

    within('div#registrations_show_avatar_image_tag') do
      expect(find(:xpath, "img[@class='avatar avatar-lg']")['src']).to match /test_image\.jpg/
    end
  end

  scenario 'users has link to edit when viewing own profile' do
    visit yams_core.user_path(me)
    expect(page).to have_link I18n.t(:edit, scope: :global)

    expect(find(:xpath, "//a/i")['class']).to match /.*icon-pencil/
  end

  # Scenario: User can see another users's profile but cannot edit
  #   Given I am signed in
  #   When I visit another users's profile
  #   Then I see their details but no edit button
  scenario "users cannot see another users's profile" do
    other = FactoryBot.create(:user, email: 'other@example.com')
    Capybara.current_session.driver.header 'Referer', root_path
    visit yams_core.user_path(other)

    expect(page).to have_content other.name
    expect(page).to have_content other.email
    expect(page).to_not  have_link I18n.t(:edit, scope: :global)
  end
end
