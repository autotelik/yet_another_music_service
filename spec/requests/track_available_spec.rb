# frozen_string_literal: true

require 'rails_helper'

describe 'track made available', type: :request do
  context 'POST' do
    context 'upload e' do
      let(:test_user) { create(:user) }

      before do
        login_as(test_user, scope: :user)
      end

      include Shoulda::Matchers::ActionController

      it 'generates an event when Track made available for download' do
        parameters = { track: attributes_for(:track, :with_audio_fixture), "availables": { download: 'true' } }

        expect { post '/tracks', params: parameters }.to change(YamsCore::Available, :count).by(1)

        track = YamsCore::Track.last
        expect(track.availables.count).to eq 1
        expect(track.available_for?(:free)).to eq false
        expect(track.available_for?(:download)).to eq true
      end
    end
  end
end
