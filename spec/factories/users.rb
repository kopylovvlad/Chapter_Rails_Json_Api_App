# == Schema Information
#
# Table name: users
#
#  id                 :bigint(8)        not null, primary key
#  email              :string           not null
#  login              :string           not null
#  encrypted_password :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryBot.define do
  factory :user do
    sequence(:email){ |i| "#{i}user@tmail.com" }
    sequence(:login){ |i| "#{i}user_login" }
    encrypted_password 'sadg23454trgfw2343'
  end
end
