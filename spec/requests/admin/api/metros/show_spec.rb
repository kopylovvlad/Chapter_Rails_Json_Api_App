require 'rails_helper'

RSpec.describe 'Admin::Api::Metros#show', type: :request do
  # checking roles
  include_examples(
    'guest can not :get',
    :admin_api_metro_path,
    FactoryBot.create(:metro).id
  )
  include_examples(
    'applicant can not :get',
    :admin_api_metro_path,
    FactoryBot.create(:metro).id
  )
  include_examples(
    'director can not :get',
    :admin_api_metro_path,
    FactoryBot.create(:metro).id
  )
  include_examples(
    'certificates can not :get',
    :admin_api_metro_path,
    FactoryBot.create(:metro).id
  )

  describe 'admin' do
    it 'should render item' do
      # prepare
      item = FactoryBot.create(:metro)
      expect(Metro.count).to eq(1)
      sign_in(admin_user)

      # action
      get(
        admin_api_metro_path(item),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['id']).to eq(item.id)
      expect(json['station']).to eq(item.station)
      expect(json['active']).to eq(item.active)
      expect(json['priority']).to eq(item.priority)
      save_file('admin_api_metros_show', json)
    end

    it 'should return 404' do
      # prepare
      expect(Metro.count).to eq(0)
      sign_in(admin_user)

      # action
      get(
        admin_api_metro_path(999),
        headers: json_header,
      )

      # check
      not_found_response(response)
      not_found_json(json)
    end
  end
end
