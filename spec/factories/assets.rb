# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    title 'MyString'
    original_format 'MyString'
    owner_id 1
    owner_type 'MyString'
    position 1
    user nil
  end
end
