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

RSpec.describe Chapter::Comment, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:chapter) }
  it { should belong_to(:user) }
  it { should belong_to(:chapter) }
  it { should have_many(:likes) }

  describe 'scopes' do
    def prepare_data
      FactoryBot.create_list(
        :comment,
        2
      )

      FactoryBot.create_list(
        :comment,
        3,
        user: nil
      )
    end

    describe '.only_system' do
      it 'should work' do
        # prepare
        prepare_data
        expect(Chapter::Comment.count).to eq(5)

        # action
        count = Chapter::Comment.only_system.count

        # check
        expect(count).to eq(3)
      end
    end

    describe '.not_system' do
      it 'should work' do
        # prepare
        prepare_data
        expect(Chapter::Comment.count).to eq(5)

        # action
        count = Chapter::Comment.not_system.count

        # check
        expect(count).to eq(2)
      end
    end
  end
end
