# == Schema Information
#
# Table name: likes
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  comment_id :integer
#
# Indexes
#
#  index_likes_on_comment_id  (comment_id)
#  index_likes_on_user_id     (user_id)
#

FactoryBot.define do
  factory :like, class: 'Chapter::Comment::Like' do

  end
end
