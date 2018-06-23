# == Schema Information
#
# Table name: chapters
#
#  id         :integer          not null, primary key
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

require 'rails_helper'

RSpec.describe Chapter, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user) }
  it { should belong_to(:user) }
end
