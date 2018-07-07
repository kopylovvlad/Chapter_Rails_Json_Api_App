# == Schema Information
#
# Table name: chapters
#
#  id         :bigint(8)        not null, primary key
#  title      :string           not null
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_chapters_on_user_id  (user_id)
#

FactoryBot.define do
  factory :chapter do
    title { Faker::Lorem.words(4).join(' ') }
    body { Faker::Lorem.paragraph }
    association :user, factory: :user
  end
end
