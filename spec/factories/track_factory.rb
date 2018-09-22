# frozen_string_literal: true
include ActionDispatch::TestProcess

FactoryBot.define do
  factory :track do
    title 'photon histories'
    description 'My House Track'
    association :user

    trait :with_audio do
      audio { fixture_file_upload(File.join(Rails.root, 'spec', 'fixtures', 'files/test.wav'), 'audio/x-wav') }
    end

    trait :with_cover do
      association :cover, factory: :cover
    end

    trait :availble_for_radio do
      after(:create) do |t, _evaluator|
        t.availables << Available.build(mode: Available.concepts[:radio], on: DateTime.now)
      end
    end
  end

  factory :track_max, parent: :track do
    length 1
    shared 1
    streamable false
    downloadable false
    permalink 'MyString'
    bitrate 1
    played 1
    downloaded 1
    favourited 1
    commented 1
    release_year 1
    release_month 1
    release_day 1
    original_format 'MyString'
    original_content_size 1
    stream_url 'MyString'
    download_url 'MyString'
    user nil
    license nil
    id3_genre nil
  end
end
