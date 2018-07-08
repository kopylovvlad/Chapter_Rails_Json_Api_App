require 'rails_helper'

RSpec.describe 'Api::Chapters::States#on_review', type: :request do
  describe 'success' do
    it 'should update item' do
      # prepare
      author = FactoryBot.create(:user)
      item = FactoryBot.create(:chapter, user: author)
      expect(Chapter.find(item.id).state).to eq('draft')
      sign_in(author)

      # action
      patch(
        on_review_api_chapter_states_path(item),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['id']).to eq(item.id)
      expect(Chapter.find(item.id).state).to eq('on_review')
      save_file('api_chapters_states_update_success', json)
    end

    it 'should create system comment' do
      # prepare
      author = FactoryBot.create(:user)
      item = FactoryBot.create(:chapter, user: author)
      expect(Chapter::Comment.count).to eq(0)
      sign_in(author)

      # action
      patch(
        on_review_api_chapter_states_path(item),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(Chapter::Comment.count).to eq(1)
      comment = Chapter::Comment.first
      expect(comment.user).to eq(nil)
      expect(comment.chapter).to eq(item)
      expect(comment.body).to eq('Author updated the chapter')
    end
  end

  describe 'chapter is on_review' do
    it 'should not do anything' do
      #on_review
      # prepare
      author = FactoryBot.create(:user)
      item = FactoryBot.create(:chapter, user: author, state: 'on_review')
      expect(Chapter.find(item.id).state).to eq('on_review')
      expect(Chapter::Comment.count).to eq(0)
      sign_in(author)

      # action
      patch(
        on_review_api_chapter_states_path(item),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['id']).to eq(item.id)
      expect(Chapter.find(item.id).state).to eq('on_review')
      expect(Chapter::Comment.count).to eq(0)
    end
  end

  describe 'guest' do
    it 'should return incorrect_data' do
      # prepare
      author = FactoryBot.create(:user)
      item = FactoryBot.create(:chapter, user: author)
      expect(Chapter.find(item.id).state).to eq('draft')

      # action
      patch(
        on_review_api_chapter_states_path(item),
        headers: json_header,
      )

      # check
      notauth_response(response)
      expect(Chapter.find(item.id).state).to eq('draft')
    end
  end

  describe 'not author' do
    it 'should return incorrect_data' do
      # prepare
      author = FactoryBot.create(:user)
      item = FactoryBot.create(:chapter, user: author)
      expect(Chapter.find(item.id).state).to eq('draft')
      sign_in(FactoryBot.create(:user))

      # action
      patch(
        on_review_api_chapter_states_path(item),
        headers: json_header,
      )

      # check
      forbidden_response(response)
      expect(Chapter.find(item.id).state).to eq('draft')
    end
  end

  describe 'does not exist' do
    it 'should return 404' do
      # prepare
      expect(Chapter.count).to eq(0)
      sign_in(FactoryBot.create(:user))

      # action
      patch(
        on_review_api_chapter_states_path(9999),
        headers: json_header,
      )

      # check
      not_found_response(response)
    end
  end
end
