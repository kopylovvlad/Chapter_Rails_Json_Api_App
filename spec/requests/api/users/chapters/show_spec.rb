require 'rails_helper'

RSpec.describe 'Api::Users::Chapters#show', type: :request do
  it 'should render item for author' do
    # prepare
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:chapter, user: user)
    expect(Chapter.count).to eq(1)
    sign_in(user)

    # action
    get(
      api_user_chapter_path(user, item),
      headers: json_header,
    )

    # check
    success_response(response)
    expect(json['id']).to eq(item.id)
    save_file('api_users_chapters_show', json)
  end

  it 'should return 404' do
    # prepare
    user = FactoryBot.create(:user)
    expect(Chapter.count).to eq(0)
    sign_in(user)

    # action
    get(
      api_user_chapter_path(user, 999),
      headers: json_header,
    )

    # check
    not_found_response(response)
    not_found_json(json)
  end

  describe 'another user' do
    it 'should return forbidden' do
      # prepare
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      chapter = FactoryBot.create(:chapter, user: user1)
      expect(Chapter.count).to eq(1)
      sign_in(user2)

      # action
      get(
        api_user_chapter_path(user1, chapter),
        headers: json_header,
      )

      # check
      forbidden_response(response)
    end
  end
end
