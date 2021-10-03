# frozen_string_literal: true

FactoryBot.define do
  factory :default_track_cover, class: YamsCore::DefaultCover do
    kind { :track }

    before(:create) do |c|
      c.image.attach(io: File.open("#{Rails.root}/app/assets/images/covers/white_label.jpg"), filename: 'white_label.jpg')
    end
  end
end
