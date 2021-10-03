# frozen_string_literal: true

require 'rails_helper'

feature 'Add Album' do
  context 'From User Menu' do
    context 'When I choose Create Album' do
      let(:album) { build(:album) }
      let(:user) { create(:user) }

      before do
        signin(user.email, user.password)
      end

      include Shoulda::Matchers::ActionController

      it 'should display the new album form and a list of my tracks' do
        visit yams_core.new_album_path
        expect(page).to have_css 'div#target-for-album-create-insertion-point'
      end
    end
  end
end
