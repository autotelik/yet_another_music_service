# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Track, type: :model do
  let(:album) { create(:album) }

  it 'saves the audio when all params present' do
    expect(create(:track, :with_audio)).to be_valid
  end

  it 'returns tracks not assigned to an Album' do
    tracks = create_list(:track, 5, :with_audio)
    AlbumTrack.create(track: tracks.first, album: album)
    expect(Track.no_album.count).to eq 4
    expect(Track.no_album.collect(&:id)).to_not include tracks.first.id
  end

  it 'can attach an optional cover' do
    track = build(:track, :with_audio)

    track.attach_cover(fixture_file('test_image.jpg'))
    expect(track.cover.image).to be_attached
  end

  it 'is not radio friendly by default' do
    track = build(:track)
    expect(track.available_for?(:free)).to eq false
  end

  it 'can be made available_for radio' do
    track = create(:track, :with_audio)

    expect(track.make_available_for(:free)).to be_a Available

    expect(track.reload.available_for?(:free)).to eq true

    expect(Track.for_radio.first).to eq track
  end

  it 'can be made available_for any concept' do
    track = create(:track, :with_audio)
    alt = create(:track, :with_audio)

    Available.concepts.keys.each do |c|
      expect(track.available_for?(c)).to eq false
      expect(track.make_available_for(c)).to be_a Available
      expect(track.reload.available_for?(c)).to eq true
      expect(alt.available_for?(c)).to eq false
    end
  end

  it 'can be created with available_for any concept' do
    Available.concepts.keys.each do |c|
      track = create(:track, :with_audio, availables_attributes: [{ mode: Available.concepts[c] }])
      expect(track).to be_valid
      expect(track.availables.size).to eq 1
      expect(track.available_for?(c)).to eq true
    end
  end
end
