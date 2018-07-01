# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
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

require 'rails_helper'

RSpec.describe Chapter::Comment::Like, type: :model do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:comment) }
  it { should belong_to(:user) }
  it { should belong_to(:comment) }

  describe 'like must be uniq' do
    describe '2 comment and 2 likes from an user' do
      it 'should work' do
        user = FactoryBot.create(:user)
        chapter = FactoryBot.create(:chapter)
        comment1 = FactoryBot.create(
          :comment,
          chapter: chapter
        )
        comment2 = FactoryBot.create(
          :comment,
          chapter: chapter
        )
        expect(Chapter::Comment::Like.count).to eq(0)

        like1 = Chapter::Comment::Like.new(user: user, comment: comment1)
        expect(like1.valid?).to eq(true)
        expect(like1.save).to eq(true)

        like2 = Chapter::Comment::Like.new(user: user, comment: comment2)
        expect(like2.valid?).to eq(true)
        expect(like2.save).to eq(true)

        expect(Chapter::Comment::Like.count).to eq(2)
      end
    end

    describe '1 comment and 2 likes from 2 users' do
      it 'should work' do
        user1 = FactoryBot.create(:user)
        user2 = FactoryBot.create(:user)
        chapter = FactoryBot.create(:chapter)
        comment = FactoryBot.create(
          :comment,
          chapter: chapter
        )
        expect(Chapter::Comment::Like.count).to eq(0)

        like1 = Chapter::Comment::Like.new(user: user1, comment: comment)
        expect(like1.valid?).to eq(true)
        expect(like1.save).to eq(true)

        like2 = Chapter::Comment::Like.new(user: user2, comment: comment)
        expect(like2.valid?).to eq(true)
        expect(like2.save).to eq(true)

        expect(Chapter::Comment::Like.count).to eq(2)
      end
    end

    describe '1 comment and 2 likes from 1 user' do
      it 'should not work' do
        user = FactoryBot.create(:user)
        comment = FactoryBot.create(
          :comment,
          chapter: FactoryBot.create(:chapter)
        )
        expect(Chapter::Comment::Like.count).to eq(0)

        like1 = Chapter::Comment::Like.new(user: user, comment: comment)
        expect(like1.valid?).to eq(true)
        expect(like1.save).to eq(true)

        like2 = Chapter::Comment::Like.new(user: user, comment: comment)
        expect(like2.valid?).to eq(false)
        expect(like2.save).to eq(false)

        expect(Chapter::Comment::Like.count).to eq(1)
      end
    end
  end
end
