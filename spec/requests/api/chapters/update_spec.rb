require 'rails_helper'

RSpec.describe 'Api::Chapters#update', type: :request do
  let(:item) do
    FactoryBot.create(
      :chapter,
      title: 'lololo',
      body: 'dsdfasdsdd',
      user_id: user1.id
    )
  end

  describe 'success' do
    it 'should update item' do
      # prepare
      item
      expect(Chapter.all.count).to eq(1)
      expect(item.user_id).to eq(user1.id)
      sign_in(user1)

      # action
      patch(
        api_chapter_path(item),
        headers: json_header,
        params: {
          chapters:
            {
              title: 'new_title',
              body: 'new_body'
            }
        }
      )

      # check
      success_response(response)
      expect(json['id']).to eq(item.id)
      expect(json['title']).to eq('new_title')
      expect(json['body']).to eq('new_body')
      expect(Chapter.all.count).to eq(1)
      save_file('api_chapters_update_success', json)
    end

    it 'should create system comment' do
      # prepare
      item
      expect(Chapter.all.count).to eq(1)
      expect(item.user_id).to eq(user1.id)
      expect(Chapter::Comment.all.count).to eq(0)
      sign_in(user1)

      # action
      patch(
        api_chapter_path(item),
        headers: json_header,
        params: {
          chapters:
            {
              title: 'new_title',
              body: 'new_body'
            }
        }
      )

      # check
      success_response(response)
      expect(Chapter.all.count).to eq(1)
      expect(Chapter::Comment.all.count).to eq(1)
      comment = Chapter::Comment.first
      expect(comment.body).to eq('Author updated the chapter')
      expect(comment.user).to eq(nil)
      expect(comment.chapter).to eq(item)
    end
  end

  describe 'invalid item' do
    it 'should return array with validation errors' do
      # prepare
      item
      expect(Chapter.all.count).to eq(1)
      expect(item.user_id).to eq(user1.id)
      sign_in(user1)

      # action
      patch(
        api_chapter_path(item),
        headers: json_header,
        params: {
          chapters:
            {
              title: '',
            }
        }
      )

      # check
      error_response(response)
      expect(json['errors'].present?).to eq(true)
      expect(json['errors'].size).to be > 0
      expect(Chapter.all.count).to eq(1)
      save_file('api_chapters_update_fail', json)
    end
  end

  describe 'guest' do
    it 'should return notauth' do
      # prepare
      item
      expect(Chapter.all.count).to eq(1)
      expect(item.user_id).to eq(user1.id)

      # action
      patch(
        api_chapter_path(item),
        headers: json_header,
        params: {
          chapters:
            {
              title: 'new_title',
              body: 'new_body'
            }
        }
      )

      # check
      notauth_response(response)
      expect(json['error']).to eq('Unauthorized')
      expect(Chapter.all.count).to eq(1)
    end
  end

  describe 'not author' do
    it 'should return forbidden' do
      # prepare
      item
      expect(Chapter.all.count).to eq(1)
      expect(item.user_id).to eq(user1.id)
      sign_in(user2)

      # action
      patch(
        api_chapter_path(item),
        headers: json_header,
        params: {
          chapters:
            {
              title: 'new_title',
              body: 'new_body'
            }
        }
      )

      # check
      forbidden_response(response)
      expect(Chapter.all.count).to eq(1)
      chapter = Chapter.first
      expect(chapter.title).to_not eq('new_title')
      expect(chapter.body).to_not eq('new_body')
    end
  end


  describe 'params require' do
    it 'should return incorrect_data' do
      # prepare
      item
      expect(Chapter.all.count).to eq(1)
      expect(item.user_id).to eq(user1.id)
      sign_in(user1)

      # action
      patch(
        api_chapter_path(item),
        headers: json_header,
        params: {
          chapters: {}
        }
      )

      # check
      error_response(response)
      error_json
      expect(Chapter.all.count).to eq(1)
    end
  end

  describe 'does not exist' do
    it 'should return 404' do
      # prepare
      expect(Chapter.all.count).to eq(0)
      sign_in(user1)

      # action
      patch(
        api_chapter_path(999),
        headers: json_header,
        params: {
          chapters: { title: '123' }
        }
      )

      # check
      not_found_response(response)
      expect(Chapter.all.count).to eq(0)
    end
  end
end
