# frozen_string_literal: true

feature 'Create Tracks', tracks: true do
  let(:user) { FactoryBot.create(:user) }

  before do
    signin(user.email, user.password)
  end

  let(:t_scope) { 'tracks.form' }

  scenario 'visit new brings up upload form' do
    visit yams_core.new_track_path

    expect(page).to have_xpath('//select[@name="track[tag_list][]"]')
    expect(page).to have_xpath('//input[@type="file"]')
    expect(page).to have_xpath('//*[@id="yamscore::cover--file-input"]')
  end

  context 'No cover supplied' do
    before do
      DefaultCover.create!(kind: :track).tap{ |c| c.image.attach(io: File.open("#{Rails.root}/app/assets/images/covers/white_label.jpg"), filename: 'white_label.jpg') }
    end

    scenario 'creates a new track with a default cover', ffs: true do
      visit yams_core.new_track_path

      page.attach_file('track[audio]', fixture_file('/files/test.wav'))

      fill_in 'track[title]', with: 'Photon Histories'

      expect { click_button('Upload') }.to change(YamsCore::Track, :count).by(1)

      expect(page).to have_text 'Track was successfully created.'
      expect(page).to have_xpath('//*[@id="datashift-audio-track-cover-img"]')
    end
  end

  scenario 'creates a new track when all required data present' do
    visit yams_core.new_track_path

    page.attach_file('track[audio]', fixture_file('test.wav'))
    page.attach_file('track[cover_attributes][image]', fixture_file('test_image.jpg'))
    fill_in 'track[title]', with: 'Photon Histories'
    fill_in 'track[description]', with: 'new banging album'

    expect { click_button('Upload') }.to change(YamsCore::Track, :count).by(1).and change(YamsCore::Cover, :count).by(1)

    expect(page).to have_text 'Track was successfully created.'
    expect(page).to have_text 'new banging album'
  end
end
