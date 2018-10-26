# frozen_string_literal: true

FactoryBot.define do
  factory :license do
    name        { 'MyString' }
    description { 'MyText' }
    url         { 'MyString' }
  end
end
