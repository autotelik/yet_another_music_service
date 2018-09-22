# frozen_string_literal: true

feature 'Pages' do
  # Scenario: Visit the home page
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see "Welcome"
  scenario 'visit the home page' do
    visit root_path
    expect(page).to have_content I18n.t(:site_name)
    expect(page).to have_text('A new take on music sharing.')
  end

  # Scenario: Visit the 'about' page
  #   Given I am a visitor
  #   When I visit the 'about' page
  #   Then I see "About the Website"
  scenario 'Visit the about page' do
    visit 'pages/about'
    expect(page).to have_content I18n.t(:site_name)
    expect(page).to have_text('built by musicians, for the benefit of artists and listeners')
  end
end
