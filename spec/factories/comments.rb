# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  chapter_id :integer
#
# Indexes
#
#  index_comments_on_chapter_id  (chapter_id)
#  index_comments_on_user_id     (user_id)
#

FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    association :user, factory: :user
    association :chapter, factory: :chapter
  end
end
