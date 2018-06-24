require 'rails_helper'

RSpec.describe 'Api::Chapters::Comments#update', type: :request do
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

  describe 'success' do
    it 'should update item' do
      # prepare
      item
      expect(Comment.all.count).to eq(1)
      new_title = Faker::Lorem.words(5).join(' ')
      sign_in(user1)

      # action
      patch(
        api_chapter_comment_path(chapter, item),
        headers: json_header,
        params: {
          comments:
            {
              body: new_title
            }
        }
      )

      # check
      success_response(response)
      expect(json['id']).to eq(item.id)
      expect(json['body']).to eq(new_title)
      expect(json['user_id']).to eq(user1.id)
      expect(json['chapter_id']).to eq(chapter.id)
      expect(Comment.all.count).to eq(1)
      save_file('api_chapters_comments_update_success', json)
    end
  end

  describe 'invalid item' do
    it 'should return array with validation errors' do
      # prepare
      item
      expect(Comment.all.count).to eq(1)
      sign_in(user1)
      expect(Comment.all.count).to eq(1)

      # action
      patch(
        api_chapter_comment_path(chapter, item),
        headers: json_header,
        params: {
          comments:
            {
              body: '',
            }
        }
      )

      # check
      error_response(response)
      expect(json['errors'].present?).to eq(true)
      expect(json['errors'].size).to be > 0
      expect(Comment.all.count).to eq(1)
      save_file('api_chapters_comments_update_fail', json)
    end
  end

  describe 'params require' do
    it 'should return incorrect_data' do
      # prepare
      item
      expect(Comment.all.count).to eq(1)
      sign_in(user1)

      # action
      patch(
        api_chapter_comment_path(chapter, item),
        headers: json_header,
        params: {
          comments: {}
        }
      )

      # check
      error_response(response)
      error_json
      expect(Comment.all.count).to eq(1)
    end
  end

  describe 'does not exist' do
    it 'should return 404' do
      # prepare
      sign_in(user1)
      expect(Comment.all.count).to eq(0)

      # action
      patch(
        api_chapter_comment_path(chapter, 999),
        headers: json_header,
        params: {
          comments: { title: '123' }
        }
      )

      # check
      not_found_response(response)
      expect(Comment.all.count).to eq(0)
    end
  end

  describe 'guest' do
    it 'should return noauth error' do
      # prepare
      item
      expect(Comment.all.count).to eq(1)

      # action
      patch(
        api_chapter_comment_path(chapter, item),
        headers: json_header,
        params: {
          comments:
            {
              body: 'new body'
            }
        }
      )

      # check
      notauth_response(response)
      expect(Comment.all.count).to eq(1)
    end
  end

  describe 'not author' do
    it 'should return forbidden' do
      # prepare
      item
      expect(Comment.all.count).to eq(1)
      new_title = Faker::Lorem.words(5).join(' ')
      sign_in(user2)

      # action
      patch(
        api_chapter_comment_path(chapter, item),
        headers: json_header,
        params: {
          comments:
            {
              body: new_title
            }
        }
      )

      # check
      forbidden_response(response)
      comment = Comment.find(item.id)
      expect(comment.body).to_not eq(new_title)
      expect(Comment.all.count).to eq(1)
    end
  end
end
