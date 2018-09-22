# frozen_string_literal: true

feature 'Create Tracks', tracks: true do
  let(:user) { FactoryBot.create(:user) }

  before do
    signin(user.email, user.password)
  end

  let(:t_scope) { 'tracks.form' }

  scenario 'visit new brings up upload form' do
    visit new_track_path

    expect(page).to have_selector('label', text: I18n.t(:available_for, scope: t_scope))
    expect(page).to have_selector('label', text: I18n.t(:cover, scope: t_scope))
    expect(page).to have_xpath('//input[@id="track_cover_attributes_image"]')
    expect(page).to have_xpath('//input[@type="file"]')
  end

  context 'No cover supplied' do
    before do
      DefaultCover.create!(kind: :track, image: File.open("#{Rails.root}/app/assets/images/covers/white_label.jpg"))
      # DefaultCover.create!(kind: :album, image: File.open("#{Rails.root}/app/assets/images/covers/white_label.jpg"))
    end

    scenario 'creates a new track with a default cover' do
      visit new_track_path

      page.attach_file('track[audio]', fixture_file('/files/test.wav'))

      fill_in 'track[title]', with: 'Photon Histories'

      expect { click_button('Upload') }.to change(Track, :count).by(1)

      expect(page).to have_text 'Track was successfully created.'
      expect(find(:xpath, "//img[@class='bg-image']")['src']).to match /thumb\/white_label\.jpg/
    end
  end

  scenario 'creates a new track when all required data present' do
    visit new_track_path

    page.attach_file('track[audio]', fixture_file('/files/test.wav'))
    page.attach_file('track[cover_attributes][image]', fixture_file('/files/test_image.jpg'))
    fill_in 'track[title]', with: 'Photon Histories'
    fill_in 'track[description]', with: 'new banging album'

    expect { click_button('Upload') }.to change(Track, :count).by(1)

    expect(page).to have_text 'Track was successfully created.'
    expect(page).to have_text 'new banging album'
    expect(find(:xpath, "//img[@class='bg-image']")['src']).to match /thumb\/test_image\.jpg/
  end
end
