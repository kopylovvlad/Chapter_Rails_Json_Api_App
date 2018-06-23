require 'rails_helper'

RSpec.describe 'Api::Users#show', type: :request do
  it 'should render item' do
    # prepare
    item = FactoryBot.create(:user)
    expect(User.count).to eq(1)

    # action
    get(
      api_user_path(item),
      headers: json_header,
    )

    # check
    success_response(response)
    expect(json['id']).to eq(item.id)
    expect(json['email']).to eq(item.email)
    expect(json['login']).to eq(item.login)
    save_file('api_users_show', json)
  end

  it 'should return 404' do
    # prepare
    expect(User.count).to eq(0)

    # action
    get(
      api_user_path(999),
      headers: json_header,
    )

    # check
    not_found_response(response)
    not_found_json(json)
  end
end
