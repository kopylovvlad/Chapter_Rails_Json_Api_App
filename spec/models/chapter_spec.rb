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

require 'rails_helper'

RSpec.describe Chapter, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user) }
  it { should belong_to(:user) }
  it { should have_many(:comments) }

  describe 'state-machine' do
    it 'should have default state' do
      i = FactoryBot.build(:chapter)
      expect(i.state).to eq('draft')

      i2 = FactoryBot.create(:chapter)
      expect(i2.state).to eq('draft')
    end

    describe 'reviewing' do
      it 'should work' do
        item = FactoryBot.build(:chapter)
        expect(item.state).to eq('draft')

        item.reviewing
        expect(item.state).to eq('on_review')
      end
    end
  end
end
