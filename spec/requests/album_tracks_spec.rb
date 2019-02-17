# frozen_string_literal: true

require 'rails_helper'

describe 'album tracks', type: :request do
  context 'POST' do
    context 'Create' do
      let(:me)        { create(:user) }
      let(:test_user) { create(:user) }

      before do
        login_as(me, scope: :user)

        allow_any_instance_of(ApplicationController).to receive(:current_user) { me }
      end

      include Shoulda::Matchers::ActionController

      it 'when I visit the dashboard I should Album Management under my Profile' do
        get '/'
        expect(response.body).to include('<a class="dropdown-item" href="/album/management">')
      end

      context 'Add Tracks' do
        let!(:tracks) { create_list(:track, 2, :with_audio, :with_cover, user: me) }
        let!(:other_tracks) { create_list(:track, 2, :with_audio, :with_cover, user: test_user) }

        it 'when I visit Album Management dashboard I should see MY Tracks ready to drag onto Albums' do
          get '/album/management', params: { page: 0 }

          # expect(response).to render_template('app/views/yams_core/album/management/_dashboard_with_dropzone')

          expect(response.body).to include('album-track-manager-dropzone')
          expect(response.body).to include('target-for-track_removal-reinsertion')

          expect(assigns(:tracks).size).to eq 2
        end
      end
    end
  end
end
