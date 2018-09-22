# frozen_string_literal: true

require 'rails_helper'

feature 'album tracks' do
  context 'Music Management' do
    context 'Create Album' do
      let(:user) { create(:user) }

      before do
        login_as(user, scope: :user)
      end

      include Shoulda::Matchers::ActionController

      context 'when I enter album details' do
        let(:album) { build(:album) }

        it 'and click submit, the new album should appear in the album list', js: true do
          visit :album_tracks

          expect(page).to have_css 'div#target-for-album-create-insertion-point'

          fill_in 'album_title', with: album.title

          # to change(Album, :count).by(1) style times out
          count = Album.count

          click_button(I18n.t('albums.form.submit'))

          expect(page).to have_text 'Album was successfully created.'
          expect(page).to have_text album.title
          expect(Album.count).to eq count + 1
        end
      end
    end
  end
end
