require 'rails_helper'

RSpec.describe 'Api::Chapters#show', type: :request do
  let(:item) do
    FactoryBot.create(
      :chapter,
      title: 'lololo',
      body: 'dsdfasdsdd',
      user_id: user1.id
    )
  end

  describe 'author' do
    it 'should delete item' do
      # prepare
      item
      expect(Chapter.count).to eq(1)
      sign_in(user1)

      # action
      delete(
        api_chapter_path(item),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(Chapter.count).to eq(0)
    end

    it 'should return 404' do
      # prepare
      expect(Chapter.count).to eq(0)
      sign_in(user1)

      # action
      delete(
        api_chapter_path(999),
        headers: json_header,
      )

      # check
      not_found_response(response)
      not_found_json(json)
    end
  end

  describe 'guest' do
    it 'should return noauth' do
      # prepare
      item
      expect(Chapter.count).to eq(1)

      # action
      delete(
        api_chapter_path(item),
        headers: json_header,
      )

      # check
      notauth_response(response)
      expect(Chapter.count).to eq(1)
    end
  end

  describe 'not author' do
    it 'should return forbidden' do
      # prepare
      item
      expect(Chapter.count).to eq(1)
      sign_in(user2)

      # action
      delete(
        api_chapter_path(item),
        headers: json_header,
      )

      # check
      forbidden_response(response)
      expect(Chapter.count).to eq(1)
    end
  end
end
