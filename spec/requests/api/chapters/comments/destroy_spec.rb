require 'rails_helper'

RSpec.describe 'Api::Chapters::Comments#destroy', type: :request do
  let(:chapter) do
    FactoryBot.create(
      :chapter,
      user: user2
    )
  end

  let(:item) do
    FactoryBot.create(
      :comment,
      body: 'lololo',
      user: user1,
      chapter: chapter
    )
  end

  describe 'author' do
    it 'should delete item' do
      # prepare
      user2
      item
      sign_in(user1)
      expect(Comment.count).to eq(1)

      # action
      delete(
        api_chapter_comment_path(chapter, item),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(Comment.count).to eq(0)
    end

    it 'should return 404' do
      # prepare
      sign_in(user1)
      expect(Comment.count).to eq(0)

      # action
      delete(
        api_chapter_comment_path(chapter, 999),
        headers: json_header,
      )

      # check
      not_found_response(response)
      not_found_json(json)
    end
  end

  describe 'guest' do
    it 'should return notauth error' do
      user2
      item
      user1
      expect(Comment.count).to eq(1)

      # action
      delete(
        api_chapter_comment_path(chapter, item),
        headers: json_header,
      )

      # check
      notauth_response(response)
      expect(Comment.count).to eq(1)
    end
  end

  describe 'not author' do
    it 'should return forbidden error' do
      user2
      item
      user1
      expect(Comment.count).to eq(1)
      sign_in(user2)

      # action
      delete(
        api_chapter_comment_path(chapter, item),
        headers: json_header,
      )

      # check
      forbidden_response(response)
      expect(Comment.count).to eq(1)
    end
  end
end
