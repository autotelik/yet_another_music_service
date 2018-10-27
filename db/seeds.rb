# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email

if(Rails.env.development?)
  user = User.find_or_create_by!(email: 'artist@example.com') do |user|
    user.name = 'aqwan'
    user.password = 'artist_change_me'
    user.password_confirmation = 'artist_change_me'
    user.confirm
  end
  puts 'CREATED Artist : ' << user.email
end

DefaultCover.create!(kind: :track).tap{ |c| c.image.attach(io: File.open("#{Rails.root}/app/assets/images/covers/white_label.jpg"), filename: 'white_label.jpg') }
DefaultCover.create!(kind: :album).tap{ |c| c.image.attach(io: File.open("#{Rails.root}/app/assets/images/covers/white_label.jpg"), filename: 'white_label.jpg') }
DefaultCover.create!(kind: :playlist).tap{ |c| c.image.attach(io: File.open("#{Rails.root}/app/assets/images/covers/white_label.jpg"), filename: 'white_label.jpg') }

