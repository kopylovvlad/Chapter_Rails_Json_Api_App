require 'rails_helper'

RSpec.describe 'Admin::Api::PositionTypes#show', type: :request do
  # checking roles
  include_examples(
    'guest can not :get',
    :admin_api_position_type_path,
    FactoryBot.create(:position_type).id
  )
  include_examples(
    'applicant can not :get',
    :admin_api_position_type_path,
    FactoryBot.create(:position_type).id
  )
  include_examples(
    'director can not :get',
    :admin_api_position_type_path,
    FactoryBot.create(:position_type).id
  )
  include_examples(
    'certificates can not :get',
    :admin_api_position_type_path,
    FactoryBot.create(:position_type).id
  )

  describe 'admin' do
    it 'should render item' do
      # prepare
      item = FactoryBot.create(:position_type)
      expect(PositionType.count).to eq(1)
      sign_in(admin_user)

      # action
      get(
        admin_api_position_type_path(item),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['id']).to eq(item.id)
      expect(json['title']).to eq(item.title)
      expect(json['active']).to eq(item.active)
      expect(json['priority']).to eq(item.priority)
      save_file('admin_api_position_types_show', json)
    end

    it 'should return 404' do
      # prepare
      expect(PositionType.count).to eq(0)
      sign_in(admin_user)

      # action
      get(
        admin_api_position_type_path(999),
        headers: json_header,
      )

      # check
      not_found_response(response)
      not_found_json(json)
    end
  end
end
