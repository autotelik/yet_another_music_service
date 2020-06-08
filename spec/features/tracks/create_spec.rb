# frozen_string_literal: true

require 'rails_helper'

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
    expect(page).to have_xpath('//*[@id="new-cover-file-upload"]')
  end

  context 'No cover supplied' do

    before do
      FactoryBot.create(:default_track_cover)
    end

    scenario 'creates a new track with a default cover', ffs: true do
      visit yams_core.new_track_path

      page.attach_file('track[audio]', fixture_file('/files/test.wav'))

      fill_in 'track[title]', with: 'Photon Histories'

      expect { click_button('Upload') }.to change(YamsCore::Track, :count).by(1)

      expect(page).to have_text 'Track was successfully created.'
      expect(page).to have_xpath('//*[@id="yams-audio-track-cover-img"]')
    end
  end

  scenario 'creates a new track when all required data present' do
    visit yams_core.new_track_path

    page.attach_file('track[audio]', fixture_file('test.wav'))
    page.attach_file('track[cover_attributes][image]', fixture_file('test_image.jpg'))
    fill_in 'track[title]', with: 'Photon Histories'
    fill_in 'track[description]', with: 'new banging album'

    #t('.' + controller.action_name + '.submit'
    #click_button I18n.t(:submit)
    expect {
      click_button(I18n.t('yams_core.track.tracks.form.new.submit'))
    }.to change(YamsCore::Track, :count).by(1)
             .and change(YamsCore::Cover, :count).by(1)

    expect(page).to have_text 'Track was successfully created.'
    expect(page).to have_text 'new banging album'
  end
end
