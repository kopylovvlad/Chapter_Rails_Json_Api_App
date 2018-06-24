require 'rails_helper'

RSpec.describe 'Api::Chapters::Comments::Likes#destroy', type: :request do
  describe 'author' do
    it 'should delete item' do
      # prepare
      item = FactoryBot.create(
        :like,
        comment: FactoryBot.create(:comment),
        user: FactoryBot.create(:user),
      )
      expect(Like.count).to eq(1)
      sign_in(item.user)

      # action
      delete(
        api_chapter_comment_likes_path(
          item.comment.chapter, item.comment
        ),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['id']).to eq(item.id)
      expect(json['user_id']).to eq(item.user.id)
      expect(json['comment_id']).to eq(item.comment.id)
      expect(Like.count).to eq(0)
      save_file('api_chapters_comments_likes_show', json)
    end

    describe 'like does not exist' do
      it 'should return 404' do
        # prepare
        user = FactoryBot.create(:user)
        comment = FactoryBot.create(:comment, user: user)
        expect(Like.count).to eq(0)
        sign_in(user)

        # action
        delete(
          api_chapter_comment_likes_path(comment.chapter, comment),
          headers: json_header,
        )

        # check
        not_found_response(response)
        not_found_json(json)
      end
    end

    describe 'comment does not exist' do
      it 'should return 404' do
        # prepare
        user = FactoryBot.create(:user)
        chapter = FactoryBot.create(:chapter)
        expect(Like.count).to eq(0)
        expect(Comment.count).to eq(0)
        sign_in(user)

        # action
        delete(
          api_chapter_comment_likes_path(chapter, 999),
          headers: json_header,
        )

        # check
        not_found_response(response)
        not_found_json(json)
      end
    end

    describe 'chapter does not exist' do
      it 'should return 404' do
        # prepare
        user = FactoryBot.create(:user)
        expect(Like.count).to eq(0)
        expect(Comment.count).to eq(0)
        expect(Chapter.count).to eq(0)
        sign_in(user)

        # action
        delete(
          api_chapter_comment_likes_path(999, 999),
          headers: json_header,
        )

        # check
        not_found_response(response)
        not_found_json(json)
      end
    end
  end

  describe 'guest' do
    it 'should return notauth' do
      # prepare
      item = FactoryBot.create(
        :like,
        comment: FactoryBot.create(:comment),
        user: FactoryBot.create(:user),
      )
      expect(Like.count).to eq(1)

      # action
      delete(
        api_chapter_comment_likes_path(
          item.comment.chapter, item.comment
        ),
        headers: json_header,
      )

      # check
      notauth_response(response)
      expect(Like.count).to eq(1)
    end
  end
end
