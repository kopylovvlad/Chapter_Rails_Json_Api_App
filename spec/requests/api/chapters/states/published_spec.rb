require 'rails_helper'

RSpec.describe 'Api::Chapters::States#published', type: :request do
  let(:author) { FactoryBot.create(:user) }
  let(:item) do
    FactoryBot.create(:chapter, user: author, state: 'approved')
  end
  describe 'success' do
    it 'should update item' do
      # prepare
      item
      expect(Chapter.find(item.id).state).to eq('approved')
      sign_in(author)

      # action
      patch(
        published_api_chapter_states_path(item),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['id']).to eq(item.id)
      expect(Chapter.find(item.id).state).to eq('published')
    end
  end


  describe 'guest' do
    it 'should return incorrect_data' do
      # prepare
      item
      expect(Chapter.find(item.id).state).to eq('approved')

      # action
      patch(
        published_api_chapter_states_path(item),
        headers: json_header,
      )

      # check
      notauth_response(response)
      expect(Chapter.find(item.id).state).to eq('approved')
    end
  end

  describe 'not author' do
    it 'should return incorrect_data' do
      # prepare
      item
      expect(Chapter.find(item.id).state).to eq('approved')
      sign_in(FactoryBot.create(:user))

      # action
      patch(
        published_api_chapter_states_path(item),
        headers: json_header,
      )

      # check
      forbidden_response(response)
      expect(Chapter.find(item.id).state).to eq('approved')
    end
  end

  describe 'does not exist' do
    it 'should return 404' do
      # prepare
      expect(Chapter.count).to eq(0)
      sign_in(FactoryBot.create(:user))

      # action
      patch(
        published_api_chapter_states_path(9999),
        headers: json_header,
      )

      # check
      not_found_response(response)
    end
  end
end
