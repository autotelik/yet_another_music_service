# The Pulse system exists to provide the storage and managmenent of consents.
#
# The system is set up to allow the processing of data processing (GDPR) consents.
#
# A User (or Grantor) grants permission to a Client (or Grantee) to process a set range of personal
# data (the Fields) for a defined set of reasons (Purposes) for a defined time.
#
# Pulse logs and manages the consent data only.
#
# It does not have features that allow for the relevant data to be transferred from the User to the Client.
#
# Pulse uses a blockchain to store the consent data, which has the benefit of making transactions immutable.
#
# The data on the blockchain is encrypted,
# so that unless you are the Grantor or Grantee,
# it is impossible to tell from the blockchain transaction
#
# Who the Grantor and Grantee are
#
# What Fields and Purposes the grant relates to
#
# When the Grant expires
#
#
require 'rails_helper'

describe 'Consents', type: :request do

  include Shoulda::Matchers::ActionController

  let(:event_store) { Rails.configuration.event_store }

  let(:grantor)     { create(:grantor) }
  let(:grantee)     { create(:grantee) }
  let(:admin_user)  { create(:grantee, :admin) }

  before(:each)do
    allow_any_instance_of(Grantees::ConsentsController).to receive(:current_grantee) { grantee }
    sign_in grantee
  end

  context 'GET' do

    let(:grants) { FactoryBot.create_list(:midtier_grant, rand(5..23)) }

    before(:each)do
      # We want Granted Consents
      allow(PulseProCore::FetchGrantsService).to receive(:call) { grants }
    end

    context 'index' do

      it 'returns list of consents that have been granted to me, so that I can process the relevant data' do
        get grantee_consents_path(grantee)

        expect(response).to render_template('consents/index')
        expect(response.body).to have_xpath(".//tr[@data-device-id]", count: grants.size)
      end
    end
  end

  context 'POST' do

    let(:grant_response) {
      {
        "message":"OK",
        "transactionid":"6030ec22f50ff4c216178ed0",
        "hash":"461b098df69d977c4883657f88b1aaa30f1bdd9760a7861dac19761db1e2d80f"
      }
    }

    let(:response_body) {
      Faraday::Response.new(status: 200, body: grant_response.to_json)
    }

    before(:each)do
      allow_any_instance_of(PulseProCore::MidTierIo::SendGrant).to receive(:dispatch) { response_body }

      #allow_any_instance_of(Grantees::ConsentsController).to receive(:current_admin_user) { grantee }
      allow_any_instance_of(Admin::PulseProCoreConsentRequestsController).to receive(:current_admin_user) { admin_user }
    end

    context 'Create' do

      let(:consent_template) { create(:consent_template) }

      let(:parameters) {
        { "consent_request"=> {
          "consent_template_id": consent_template.id,
          "grantor_id": grantor.id,
          "end_date"=>"2021-02-19" }
        }
      }

      before(:each)do
        allow_any_instance_of(PulseProCore::MidTierIo::SendGrant).to receive(:dispatch) { response_body }
      end

      it 'when all params valid - creates a new ConsentRequest' do
        expect {
          post '/admin/pulse_pro_core_consent_requests', params: parameters
        }.to change(PulseProCore::ConsentRequest, :count).by(1)

        expect(response).to redirect_to assigns(:consent_request)
      end

      it 'when all params valid - triggers a ConsentRequestCreatedEvent' do
        post '/admin/pulse_pro_core_consent_requests', params: parameters

        expect(event_store).to have_published(an_event(PulseProCore::ConsentRequestCreatedEvent))
      end

      it 'after create displays listing of ConsentRequests including new one' do
        sign_in admin_user

        get '/admin/pulse_pro_core_consent_requests', params: parameters

        expect(response).to render_template('active_admin/resource/index')
      end

    end
  end

end
