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

describe 'Revoke Consents', type: :request do

  include Shoulda::Matchers::ActionController

  let(:grantee)     { create(:grantee) }

  let(:consent_request)  { create(:consent_request, :published) }

  before(:each)do
    allow_any_instance_of(Grantees::ConsentsController).to receive(:current_grantee) { grantee }
    sign_in grantee
  end

  context 'DESTROY' do

    before(:each)do
      allow_any_instance_of(PulseProCore::RevokeGrant).to receive(:call) { true }
    end

    it "revokes a GRANT" do
      delete "/grantees/#{grantee.id}/revoke_consents/#{consent_request.id}?tx_hash=35e62f4b9fae773e5f6d66d684a18cb71d7bb6e2b3ef4eb2a356972052bef1cb"
      expect(response.status).to eq 302
      expect(response).to redirect_to("/grantees/#{grantee.id}/consents")
    end

  end

end
