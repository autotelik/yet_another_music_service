# frozen_string_literal: true

feature 'Navigation links', :devise do
  # Scenario: View navigation links
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see links relevant when no current user
  scenario 'view navigation links' do
    visit root_path

    expect(page).to have_link(I18n.t(:radio, scope: :global))

    expect(page).to have_link(I18n.t('sign_in'))
    expect(page).to have_link(I18n.t('sign_up'))

    expect(page).to_not have_link(I18n.t(:profile, scope: :global))
    expect(page).to_not have_link(I18n.t(:tracks, scope: :global))
  end

  context 'Current User' do
    let(:user) { FactoryBot.create(:user) }

    before do
      signin(user.email, user.password)
    end

    # Scenario: View navigation links
    #   Given I am a signed in user
    #   When I visit the home page
    #   Then I see links relevant for a current user
    scenario 'view navigation links' do
      visit root_path

      expect(page).to have_link(I18n.t(:radio, scope: :global))
      #expect(page).to have_link(I18n.t(:albums, scope: :global))
     # expect(page).to have_link(I18n.t(:artists, scope: :global))
      expect(page).to have_link(I18n.t(:tracks, scope: :global))

      expect(page).to have_link(I18n.t(:profile, scope: :global))
      expect(page).to have_link(I18n.t(:upload, scope: :global))

      expect(page).to have_link(I18n.t(:sign_out))
    end
  end
end
