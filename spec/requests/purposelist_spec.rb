# import server from '../src/index'
# import request from 'supertest'
# import {expect} from 'chai'
# import assert from 'assert'
# import granteeKey from '../src/models/granteeKeys'
# import * as cmpcrypt from '../src/cmpcrypt'
# import SignedTx from '../src/classes/signedtx'
# import PurposeListTx from '../src/classes/purposelisttx'

#validGranteeKey = cmpcrypt.generateECKeyPair()
#pubKeyString = validGranteeKey.getPublic(true,'hex')

describe 'PurposeList List API Tests' do

	include Shoulda::Matchers::ActionController

	#let(:event_store) { Rails.configuration.event_store }

	#let(:grantor)     { create(:grantor) }
	#let(:grantee)     { create(:grantee) }
	#	let(:admin_user)  { create(:grantee, :admin) }

	before(:each)do
		#allow_any_instance_of(Grantees::ConsentsController).to receive(:current_grantee) { grantee }
		sign_in grantee
	end

	context 'POST' do

		let(:purpose_response) {
			{
				"message":"OK",
				"transactionid":"6030ec22f50ff4c216178ed0",
				"hash":"461b098df69d977c4883657f88b1aaa30f1bdd9760a7861dac19761db1e2d80f"
			}
		}

		let(:response_body) {
			Faraday::Response.new(status: 200, body: purpose_response.to_json)
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

			it 'PUT /api/v1/purposelist/ returns a 400 error if no empty object supplied' do
				response = await request(server)
													 .put('/api/v1/purposelist')
				expect(response.status).to eq (400)
			end

			it 'when all params valid - pushes PurposeList to the MidTier' do
				expect {
					put '/admin/pulse_pro_core_consent_requests', params: parameters
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

			it 'PUT /api/v1/purposelist/ returns a 400 error if no empty object supplied' do
				response = await request(server)
													 .put('/api/v1/purposelist')
				expect(response.status).to eq (400)
			end

			it 'PUT /api/v1/purposelist/ returns a 400 error if no purposelist is present' do
				not_a_purposelist = SignedTx.new({revoke: "Revoke Data", grant_ref: "1", key1: "key1random", key2: "key2random" } )
				not_a_purposelist.sign(validGranteeKey)
				response = await request(server)
													 .put('/api/v1/purposelist')
													 .send(not_a_purposelist)
				expect(response.status).to eq (400)
			end

			it 'PUT /api/v1/purposelist/ returns a 400 error if no signature is present' do
				purposelist = SignedTx.new({purposes: [[2, "a"]] } )
				response = await request(server)
													 .put('/api/v1/purposelist')
													 .send(purposelist)
				expect(response.status).to eq (400)
			end


			it 'PUT /api/v1/purposelist/ should check that purpose ids exist in the master database' do
				purposelist = SignedTx.new( { purposes: [["9999", "Out Of Range"]] } )
				purposelist.sign(validGranteeKey)
				response = await request(server)
													 .put('/api/v1/purposelist')
													 .send(purposelist)
				expect(response.status).to eq (400)
			end

			it 'PUT /api/v1/purposelist/ should check that field id and names match the master database' do
				purposelist = SignedTx.new( {purposes: [["1", "Wrong name"]] } )
				purposelist.sign(validGranteeKey)
				response = await request(server)
													 .put('/api/v1/purposelist')
													 .send(purposelist)
				expect(response.status).to eq (400)
			end

			it 'PUT /api/v1/purposelist/ should verify the signature is valid' do
				purposelist = SignedTx.new({ purposes: ["1", "Identity Verification"] } )
				purposelist.sig = "BADSIG"
				response = await request(server)
													 .put('/api/v1/purposelist')
													 .send(purposelist)
				expect(response.status).to eq (400)
			end

			it 'PUT /api/v1/purposelist/ should verify the signer is in the list of allowed publishers' do
				keyPair = cmpcrypt.generateECKeyPair()
				#  Don't save as valid key in publishers table
				purposelist = SignedTx.new({purposes:[{ purpose: "1", name: "Identity Verification"},
																							{ purpose: "2", name: "Payment History Verification"}] } )
				purposelist.sign(keyPair)

				response = await request(server)
													 .put('/api/v1/purposelist')
													 .send(purposelist)
				expect(response.status).to eq (400)

			end

			it 'PUT /api/v1/purposelist/ should return a transaction id on success' do
				purposelist = SignedTx.new({ purposes:[{ purpose: "1", name: "Identity Verification"},
																							 { purpose: "2", name: "Payment History Verification"}] } )
				purposelist.sign(validGranteeKey)

				response = await request(server)
													 .put('/api/v1/purposelist')
													 .send(purposelist)
				expect(response.status).to eq (200)
				expect(response.body).to.have.property('transactionid')
			end

			it 'PUT /api/v1/purposelist/ should prevent duplicate entries' do
				#purposelist = SignedTx.new({ purposes : [{ purpose : "1", name : "Identity Verification"}] } )
				purposelist.sign(validGranteeKey)

				response = await request(server)
													 .put('/api/v1/purposelist')
													 .send(purposelist)
				expect(response.status).to eq (200)
				expect(response.body).to.have.property('transactionid')

				response2 = await request(server)
														.put('/api/v1/purposelist')
														.send(purposelist)
				expect(response2.status).to eq (400)
			end

			it  'GET /api/v1/purposelist/ should return a 400 error if no transaction id is provided' do
				requestObj = {}
				response = await request(server)
													 .get('/api/v1/purposelist')
													 .send(requestObj)
				expect(response.status).to eq (400)
			end


			it  'GET /api/v1/purposelist/{hashvalue} should return a purposelist if the request is valid' do
				purposelistTx = SignedTx.new( {purposes: [{ purpose: "3", name: "Third Party data analysis"}] } )
				purposelistTx.sign(validGranteeKey)

				putResponse = await request(server)
															.put('/api/v1/purposelist')
															.send(purposelistTx)
				expect(putResponse.status).to eq (200)
				hashvalue = putResponse.body.hash

				getResponse = await request(server)
															.get('/api/v1/purposelist/' + hashvalue)
				expect(getResponse.status).to eq (200)
				responseTx = PurposeListTx.new(getResponse.body[0].tx)
				expect(responseTx).to.deep.equal(purposelistTx.tx.unsignedTx)
			end

			it  'GET /api/v1/purposelist/{hashvalue} should return an error is a bad hash is passed' do
				response = await request(server)
													 .get('/api/v1/purposelist/1')
				expect(response.status).to eq (400)
			end

			it  'GET /api/v1/purposelist/{hashvalue} should return a 404 error if the hash does not exist' do
				response = await request(server)
													 .get('/api/v1/purposelist/1234567890123456789012345678901234567890123456789012345678901234')
				expect(response.status).to eq (404)
			end

		end

	end
end
