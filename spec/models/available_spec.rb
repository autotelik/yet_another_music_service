# frozen_string_literal: true
require 'rails_helper'

# TODO: test belongs in the engine - fix the dummy app and move there
#
describe YamsCore::Available do

  it "triggers do_something on save" do
    avail = build(:available_free)
    expect(avail).to receive(:publish_made_available)
    avail.save!
  end

  context 'Downstream' do
    let(:event_store)  { RailsEventStore::Client.new }
    let(:avail)         { create(:available_free) }

    after(:each) do
      YamsEvents::ItemMadeAvailableHandler.clear
    end

    let(:create_track) { create(:track, :with_audio, :available_for_download) }

    it 'publishes an event when an object such as a track is made available' do
      create_track
      expect(event_store).to have_published(an_event(YamsEvents::ItemMadeAvailableHandler))
    end

    it 'is handled by event store and subscriber ItemMadeAvailableHandler is started' do
      expect { create_track }.to change(YamsEvents::ItemMadeAvailableHandler.jobs, :size).by(1)
    end

    it 'has a worker spun off by subscriber ItemMadeAvailableHandler to create a new Products' do
      create_track

      expect {
        YamsEvents::ItemMadeAvailableHandler.drain
      }.to change(YamsEvents::ItemMadeAvailableWorker.jobs, :size).by(1)

      expect { YamsEvents::ItemMadeAvailableWorker.drain }.to change(YamsEvents::Product, :count).by(1)
    end

    it 'creates a new Products against the item being made available', ffs: true do
      track = create_track

      YamsEvents::ItemMadeAvailableHandler.drain
      YamsEvents::ItemMadeAvailableWorker.drain

      product = YamsEvents::Product.last

      expect(product.sellable_type).to eq  track.class.name
      expect(product.sellable_id).to eq  track.id
      expect(product.sellable).to eq  track

    end

    it 'uses the available meta dta to set price and currency on new Product', ffs: true do
      track = create(:track, :with_audio)
      track.availables << create(:available, mode: :download,  meta_data:  { price: 1250, ccy: :satoshi } )

      pp  track.availables

      YamsEvents::ItemMadeAvailableHandler.drain
      YamsEvents::ItemMadeAvailableWorker.drain

      product = YamsEvents::Product.last

      expect(product.price.amount).to eq  1250
      expect(product.price.satoshi?).to eq true
      expect(product.price.ccy).to eq  :satoshi
    end

  end

end
