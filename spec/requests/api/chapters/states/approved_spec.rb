require 'rails_helper'

RSpec.describe 'Api::Chapters::States#approved', type: :request do
  let(:author) { FactoryBot.create(:user) }
  let(:item) do
    FactoryBot.create(:chapter, user: author, state: 'on_review')
  end

  def prepare_data
    item
    expect(Chapter.find(item.id).state).to eq('on_review')
    FactoryBot.create_list(:comment, 4, chapter: item)
    FactoryBot.create_list(:user, 3)
    expect(User.count).to eq(8)
    expect(item.comments.count).to eq(4)
  end

  describe 'success' do
    it 'should update item' do
      # prepare
      prepare_data
      sign_in(author)

      # action
      patch(
        approved_api_chapter_states_path(item),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['id']).to eq(item.id)
      expect(Chapter.find(item.id).state).to eq('approved')
    end
  end

  describe 'less comments' do
    it 'should not update item' do
      # prepare
      item
      expect(Chapter.find(item.id).state).to eq('on_review')
      FactoryBot.create_list(:comment, 2, chapter: item)
      FactoryBot.create_list(:user, 5)
      expect(User.count).to eq(8)
      expect(item.comments.count).to eq(2)
      sign_in(author)

      # action
      patch(
        approved_api_chapter_states_path(item),
        headers: json_header,
      )

      # check
      error_response(response)
      expect(json['errors'].size).to be > 0
      expect(Chapter.find(item.id).state).to eq('on_review')
    end
  end

  describe 'guest' do
    it 'should return incorrect_data' do
      # prepare
      prepare_data

      # action
      patch(
        approved_api_chapter_states_path(item),
        headers: json_header,
      )

      # check
      notauth_response(response)
      expect(Chapter.find(item.id).state).to eq('on_review')
    end
  end

  describe 'not author' do
    it 'should return incorrect_data' do
      # prepare
      prepare_data
      sign_in(FactoryBot.create(:user))

      # action
      patch(
        approved_api_chapter_states_path(item),
        headers: json_header,
      )

      # check
      forbidden_response(response)
      expect(Chapter.find(item.id).state).to eq('on_review')
    end
  end

  describe 'does not exist' do
    it 'should return 404' do
      # prepare
      expect(Chapter.count).to eq(0)
      sign_in(FactoryBot.create(:user))

      # action
      patch(
        approved_api_chapter_states_path(9999),
        headers: json_header,
      )

      # check
      not_found_response(response)
    end
  end
end
