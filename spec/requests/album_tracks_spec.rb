# frozen_string_literal: true

require 'rails_helper'

describe 'album tracks', type: :request do
  context 'POST' do
    context 'Create' do
      let(:me)        { create(:user) }
      let(:test_user) { create(:user) }

      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user) { me }
      end

      include Shoulda::Matchers::ActionController

      it 'when I visit the dashboard I should see the New album Form, with on-create dynamic insertion point' do
        get '/album_tracks'

        expect(response).to render_template('albums/_dashboard_with_dropzone')

        expect(response.body).to include('toggle-new-album-form')
        expect(response.body).to include('id="target-for-album-create-insertion-point"')
      end

      context 'Tracks' do
        let!(:tracks) { create_list(:track, 2, :with_audio, :with_cover, user: me) }
        let!(:other_tracks) { create_list(:track, 2, :with_audio, :with_cover, user: test_user) }

        it 'when I visit the dashboard I should see MY Tracks ready to drag onto an album' do
          get '/album_tracks'

          expect(assigns(:tracks).size).to eq 2
          expect(response.body).to match(/value="Create album"/)
        end
      end
    end
  end
end
