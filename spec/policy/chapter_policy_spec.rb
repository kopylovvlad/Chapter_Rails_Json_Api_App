require 'rails_helper'

RSpec.describe ChapterPolicy, type: :model do
  describe '4/7' do
    it 'can be approving' do
      # 4/7
      author = FactoryBot.create(:user)
      chapter = FactoryBot.create(:chapter, user: author, state: 'on_review')
      FactoryBot.create_list(:comment, 4, chapter: chapter)
      FactoryBot.create_list(:user, 3)
      expect(User.count).to eq(8)
      expect(chapter.comments.count).to eq(4)

      # action
      answer = ChapterPolicy.able_to_approving?(chapter)

      # check
      expect(answer).to eq(true)
    end
  end

  describe 'chapter without comments' do
    it 'can be approving' do
      # 4/7
      author = FactoryBot.create(:user)
      chapter = FactoryBot.create(:chapter, user: author, state: 'on_review')
      expect(User.count).to eq(1)
      expect(chapter.comments.count).to eq(0)

      # action
      answer = ChapterPolicy.able_to_approving?(chapter)

      # check
      expect(answer).to eq(false)
    end
  end

  describe '2/7' do
    it 'can not be approving' do
      # 2/7
      author = FactoryBot.create(:user)
      chapter = FactoryBot.create(:chapter, user: author, state: 'on_review')
      FactoryBot.create_list(:comment, 2, chapter: chapter)
      FactoryBot.create_list(:user, 5)
      expect(User.count).to eq(8)
      expect(chapter.comments.count).to eq(2)

      # action
      answer = ChapterPolicy.able_to_approving?(chapter)

      # check
      expect(answer).to eq(false)
    end
  end
end
