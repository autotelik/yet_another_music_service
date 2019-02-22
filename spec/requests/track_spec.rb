# frozen_string_literal: true

require 'rails_helper'

describe 'track', type: :request do
  context 'POST' do
    context 'upload e' do
      let(:me) { create(:user) }

      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user) { me }
      end

      include Shoulda::Matchers::ActionController

      it 'when all params valid - stores a wav file as a new track' do
        parameters = { track: attributes_for(:track, :with_audio_fixture) }

        expect { post '/tracks', params: parameters }.to change(YamsCore::Track, :count).by(1)

        expect(response).to redirect_to(assigns(:track))
        expect(controller).to set_flash[:notice].to(/successfully created/)
      end

      it 'stores a cover image against the new track' do
        parameters = { track: attributes_for(:track, :with_audio_fixture).merge(cover_attributes: {
                                                                                  image: fixture_file_upload('/files/test_image.jpg', 'image/jpeg')
                                                                                }) }

        expect { post '/tracks', params: parameters }.to change(YamsCore::Cover, :count).by(1)

        expect(response).to redirect_to(assigns(:track))
        expect(controller).to set_flash[:notice].to(/successfully created/)
      end

      it 'sets available for fields correctly', ffs: true do
        parameters = { track: attributes_for(:track, :with_audio_fixture), "availables": { free: 'true' } }

        expect { post '/tracks', params: parameters }.to change(YamsCore::Available, :count).by(1)

        track = YamsCore::Track.last
        expect(track.availables.count).to eq 1
        expect(track.available_for?(:free)).to eq true
        expect(track.available_for?(:download)).to eq false
      end

      it 'sets suitable error notice when no title provided' do
        parameters = { track: attributes_for(:track, :with_audio_fixture).except(:title) }

        expect { post '/tracks', params: parameters }.to change(YamsCore::Track, :count).by(0)
        expect(assigns(:track).errors).to have_key :title
        expect(response).to render_template('tracks/new')
      end
    end
  end
end
