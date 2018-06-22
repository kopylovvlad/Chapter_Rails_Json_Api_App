require 'rails_helper'

RSpec.describe 'Admin::Api::Users#show', type: :request do
  # checking roles
  include_examples(
    'guest can not :get',
    :admin_api_user_path,
    FactoryBot.create(:user).id
  )
  include_examples(
    'applicant can not :get',
    :admin_api_user_path,
    FactoryBot.create(:user).id
  )
  include_examples(
    'director can not :get',
    :admin_api_user_path,
    FactoryBot.create(:user).id
  )
  include_examples(
    'certificates can not :get',
    :admin_api_user_path,
    FactoryBot.create(:user).id
  )

  describe 'admin' do
    it 'should render item' do
      # prepare
      item = FactoryBot.create(:user)
      expect(User.count).to eq(1)
      sign_in(admin_user)

      # action
      get(
        admin_api_user_path(item),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['id']).to eq(item.id)
      # TODO: add attributes
      # expect(json['title']).to eq(item.title)
      # expect(json['active']).to eq(item.active)
      # expect(json['priority']).to eq(item.priority)
      save_file('admin_api_users_show', json)
    end

    it 'should return 404' do
      # prepare
      expect(User.count).to eq(0)
      sign_in(admin_user)

      # action
      get(
        admin_api_user_path(999),
        headers: json_header,
      )

      # check
      not_found_response(response)
      not_found_json(json)
    end
  end
end
