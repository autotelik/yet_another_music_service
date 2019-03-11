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

    end
  end
end
