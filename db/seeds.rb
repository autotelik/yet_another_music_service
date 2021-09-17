# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
if(Rails.env.development?)
  DatabaseCleaner.clean_with(:truncation)
end

user = YamsCore::User.find_or_create_by!(email: ENV.fetch('YAMS_ADMIN_EMAIL', 'admin@example.com')) do |user|
  user.name = 'admin'
  user.password =  ENV.fetch('YAMS_ADMIN_PASSWORD', 'admin123')
  user.password_confirmation = ENV.fetch('YAMS_ADMIN_PASSWORD', 'admin123')
  user.confirm
  user.admin!
end

puts 'CREATED ADMIN USER : ' << user.email

if(Rails.env.development?)

  user = YamsCore::User.find_or_create_by!(email: 'aqwan@yams.fm') do |user|
    user.name = 'aqwan'
    user.password = 'aqwan123'
    user.password_confirmation = 'aqwan123'
    user.confirm
  end

  puts 'CREATED Artist USER : ' << user.email
  
  user = YamsCore::User.find_or_create_by!(email: 'artist@example.com') do |user|
    user.name = 'yams'
    user.password = 'artist_change_me'
    user.password_confirmation = 'artist_change_me'
    user.confirm
  end
  puts 'CREATED Artist USER : ' << user.email
end

media = "#{Rails.root}/app/assets/images/covers/white_label.jpg"

YamsCore::DefaultCover.new(kind: :track).tap { |c| c.image.attach(io: File.open(media), filename: 'white_label.jpg'); c.save! }
YamsCore::DefaultCover.new(kind: :album).tap{ |c| c.image.attach(io: File.open(media), filename: 'white_label.jpg'); c.save! }
YamsCore::DefaultCover.new(kind: :playlist).tap{ |c| c.image.attach(io: File.open(media), filename: 'white_label.jpg'); c.save! }

YamsCore::DefaultCover.new(kind: :artist).tap{ |c| c.image.attach(io: File.open("#{Rails.root}/app/assets/images/covers/default_avatar.png"), filename: 'default_avatar.png'); c.save! }
YamsCore::DefaultCover.new(kind: :user).tap{ |c| c.image.attach(io: File.open("#{Rails.root}/app/assets/images/covers/default_avatar.png"), filename: 'default_avatar.png'); c.save! }

