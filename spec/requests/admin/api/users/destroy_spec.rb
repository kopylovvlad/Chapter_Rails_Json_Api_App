require 'rails_helper'

RSpec.describe 'Admin::Api::Users#show', type: :request do
  # checking roles
  include_examples(
    'guest can not :delete',
    :admin_api_user_path,
    FactoryBot.create(:user).id
  )
  include_examples(
    'applicant can not :delete',
    :admin_api_user_path,
    FactoryBot.create(:user).id
  )
  include_examples(
    'director can not :delete',
    :admin_api_user_path,
    FactoryBot.create(:user).id
  )
  include_examples(
    'certificates can not :delete',
    :admin_api_user_path,
    FactoryBot.create(:user).id
  )

  describe 'admin' do
    it 'should delete item' do
      # prepare
      item = FactoryBot.create(:user)
      expect(User.count).to eq(1)
      sign_in(admin_user)

      # action
      delete(
        admin_api_user_path(item),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['id']).to eq(item.id)
      expect(json['title']).to eq(item.title)
      expect(json['locator']).to eq(item.locator)
      expect(json['descriptions']).to eq(item.descriptions)
      expect(json['content']).to eq(item.content)
      expect(json['published_at']).to eq(item.published_at.strftime('%Y-%m-%d %H:%M:%S +0000'))
      expect(Page.count).to eq(0)
    end

    it 'should return 404' do
      # prepare
      expect(User.count).to eq(0)
      sign_in(admin_user)

      # action
      delete(
        admin_api_user_path(999),
        headers: json_header,
      )

      # check
      not_found_response(response)
      not_found_json(json)
    end
  end
end
