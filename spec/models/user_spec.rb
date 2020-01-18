# frozen_string_literal: true
require 'rails_helper'

# TODO: test belongs in the engine - fix the dummy app and move there
#
describe YamsCore::User do

  it "triggers do_something on save" do
    user = build(:user)
    expect(user).to receive(:publish_new_user)
    user.save
  end

  context 'Downstream' do
    let(:event_store)  { RailsEventStore::Client.new }
    let(:user)         { create(:user) }

    after(:each) do
      YamsEvents::NewUserCreatedHandler.clear
    end

    it 'publishes an event when a user created' do
      create(:user)
      expect(event_store).to have_published(an_event(YamsEvents::NewUserCreated))
    end

    it 'is handled by event store and subscriber NewUserCreatedHandler is started' do
      expect { create(:user) }.to change(YamsEvents::NewUserCreatedHandler.jobs, :size).by(1)
    end

    it 'starts subscriber NewUserCreatedHandler which creates a btc pay store job', ffs: true do
      create(:user)

      expect {
        YamsEvents::NewUserCreatedHandler.drain
      }.to change(YamsEvents::CreateBtcpayStoreWorker.jobs, :size).by(1)

      YamsEvents::CreateBtcpayStoreWorker.drain
    end

  end

end
