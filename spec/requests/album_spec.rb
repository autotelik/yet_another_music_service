# frozen_string_literal: true

require 'rails_helper'

describe 'Album', type: :request do
  context 'Create' do
    let(:test_user) { create(:user) }

    before do
      login_as(test_user, scope: :user)
    end

    include Shoulda::Matchers::ActionController

    it 'when all params valid - creates a new album' do
      parameters = { album: attributes_for(:album).merge(published_state: 'draft') }

      expect { post '/albums', params: parameters }.to change(YamsCore::Album, :count).by(1)

      expect(controller).to set_flash[:notice].to(/successfully created/)
      expect(response).to redirect_to assigns(:album)
    end
  end
end
