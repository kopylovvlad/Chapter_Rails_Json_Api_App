require 'rails_helper'

RSpec.describe 'Api::Chapters::Comments::likes#create', type: :request do
  let(:chapter) { FactoryBot.create(:chapter) }
  let(:comment) do
    FactoryBot.create(
      :comment,
      chapter: chapter
    )
  end

  describe 'auth' do
    describe 'success' do
      it 'should create item' do
        # prepare
        count = Chapter::Comment::Like.all.count
        sign_in(user1)

        # action
        post(
          api_chapter_comment_likes_path(chapter, comment),
          headers: json_header,
        )

        # check
        success_response(response)
        expect(json['id']).to_not eq(nil)
        expect(json['user_id']).to eq(user1.id)
        expect(json['comment_id']).to eq(comment.id)
        expect(Chapter::Comment::Like.all.count).to eq(count + 1)
        save_file('api_chapters_comments_likes_create_success', json)
      end
    end

    describe 'comment is system' do
      it 'should return errors' do
        # prepare
        count = Chapter::Comment::Like.all.count
        sys_comment = ChapterCommentMutator.create_system_comment(chapter)
        sign_in(user1)

        # action
        post(
          api_chapter_comment_likes_path(chapter, sys_comment),
          headers: json_header,
        )

        # check
        error_response(response)
        expect(json['errors'].keys.size).to be > 0
        expect(Chapter::Comment::Like.all.count).to eq(count)
      end
    end

    describe 'comment does not exist' do
      it 'should return 404' do
        # prepare
        count = Chapter::Comment::Like.all.count
        sign_in(user1)

        # action
        post(
          api_chapter_comment_likes_path(chapter, 9999),
          headers: json_header,
        )

        # check
        not_found_response(response)
        expect(Chapter::Comment::Like.all.count).to eq(count)
        save_file('api_chapters_comments_likes_create_fail', json)
      end
    end

    describe 'chapter does not exist' do
      it 'should return 404' do
        # prepare
        count = Chapter::Comment::Like.all.count
        sign_in(user1)

        # action
        post(
          api_chapter_comment_likes_path(99, 9999),
          headers: json_header,
        )

        # check
        not_found_response(response)
        expect(Chapter::Comment::Like.all.count).to eq(count)
      end
    end
  end

  describe 'guest' do
    it 'should return no auth' do
      # prepare
      count = Chapter::Comment::Like.all.count

      # action
      post(
        api_chapter_comment_likes_path(chapter, comment),
        headers: json_header,
      )

      # check
      notauth_response(response)
      expect(Chapter::Comment::Like.all.count).to eq(count)
    end
  end
end
