# frozen_string_literal: true

require 'rails_helper'

describe 'album', type: :request do
  context 'POST' do
    context 'Create' do
      let(:test_user) { create(:user) }

      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user) { test_user }
      end

      include Shoulda::Matchers::ActionController

      it 'when all params valid - stores a wav file as a new track' do
        parameters = { album: attributes_for(:album).merge(published_state: 'draft') }

        expect { post '/albums', params: parameters }.to change(Album, :count).by(1)

        expect(controller).to set_flash[:notice].to(/successfully created/)
        expect(response).to redirect_to(album_url(assigns(:album)))

      end
    end
  end
end
