# frozen_string_literal: true

FactoryBot.define do
  factory :album do
    title       { Faker::Name.title }
    description { Faker::Music.instrument }
    association :user
  end
end
