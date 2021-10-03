require 'rails_helper'

describe 'NotifyConsentRequestService' do

  let(:subject) { NotifyConsentRequestService }

  let(:grantor)     { create(:grantor) }
  let(:grantee)     { create(:grantee) }
  let(:admin_user)  { create(:grantee, :admin) }

  let(:grant_response) {
    {
      "message":"OK",
      "transactionid":"6030ec22f50ff4c216178ed0",
      "hash":"461b098df69d977c4883657f88b1aaa30f1bdd9760a7861dac19761db1e2d80f"
    }
  }


end
