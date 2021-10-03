require 'rails_helper'

RSpec.describe "Sessions" do

  let(:grantee) { create(:grantee) }

  let(:grants) { FactoryBot.create_list(:midtier_grant, rand(5..23)) }

  before(:each)do
    allow_any_instance_of(Grantees::ConsentsController).to receive(:current_grantee) { grantee }

    # We want Granted Consents
    allow(PulseProCore::FetchGrantsService).to receive(:call) { grants }
  end


  # Pulse Customers that want to view Consent data belonging to Grantors
  #
  it "signs GRANTEES in and out" do
    sign_in grantee
    get root_path
    expect(response).to render_template('pages/home')

    sign_out grantee
    get root_path
    expect(response).not_to render_template(:index)
  end

  # Pulse Customers that have admin rights to manage Consent data belonging to Grantors
  # This is Modelled as admin_user
  #
  it "signs admin GRANTEES in and out" do
    admin_user = create(:grantee, :admin)

    sign_in admin_user, scope: Devise::Mapping.find_scope!(admin_user)

    get admin_root_path
    expect(response).to render_template('active_admin/page/index')

    get grantee_consents_path(grantee)
    expect(response).to render_template('consents/index')

    sign_out admin_user
    get admin_root_path
    expect(response).not_to render_template('active_admin/page/index')
  end

end