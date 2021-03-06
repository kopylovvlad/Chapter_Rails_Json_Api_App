# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'factory_bot'
require 'faker'
# Dir['./spec/factories/*.rb'].each { |file| require file }

user1 = User.find_or_create_by(
  email: 'user1email@tmail.com',
  login: 'user1email',
  encrypted_password: PasswordEncryptor.call('super_pass')
)
user2 = User.find_or_create_by(
  email: 'user2email@tmail.com',
  login: 'user2email',
  encrypted_password: PasswordEncryptor.call('lololo')
)

(2 + rand(3)).times do |i|
  chapter = FactoryBot.create(
    :chapter,
    user: [user1, user2].sample
  )

  (2 + rand(3)).times do |i2|
    comment = FactoryBot.create(
      :comment,
      chapter: chapter,
      user: [user1, user2].sample
    )

    if [true, false].sample == true
      FactoryBot.create(
        :like,
        user: [user1, user2].sample,
        comment: comment
      )
    end
  end
end


