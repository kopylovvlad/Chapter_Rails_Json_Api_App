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

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:chapter) }
  it { should belong_to(:user) }
  it { should belong_to(:chapter) }
  it { should have_many(:likes) }
end
