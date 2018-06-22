require 'rails_helper'

RSpec.describe 'Admin::Api::Positions#show', type: :request do
  # checking roles
  include_examples(
    'guest can not :get',
    :admin_api_position_path,
    FactoryBot.create(:position).id
  )
  include_examples(
    'applicant can not :get',
    :admin_api_position_path,
    FactoryBot.create(:position).id
  )
  include_examples(
    'director can not :get',
    :admin_api_position_path,
    FactoryBot.create(:position).id
  )
  include_examples(
    'certificates can not :get',
    :admin_api_position_path,
    FactoryBot.create(:position).id
  )

  describe 'admin' do
    it 'should render item' do
      # prepare
      item = FactoryBot.create(:position)
      expect(Position.count).to eq(1)
      sign_in(admin_user)

      # action
      get(
        admin_api_position_path(item),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['id']).to eq(item.id)
      expect(json['priority']).to eq(item.priority)
      expect(json['name']).to eq(item.name)
      expect(json['full_name']).to eq(item.full_name)
      expect(json['position_type_id']).to eq(item.position_type_id)
      expect(json['active']).to eq(item.active)
      save_file('admin_api_positions_show', json)
    end

    it 'should return 404' do
      # prepare
      expect(Position.count).to eq(0)
      sign_in(admin_user)

      # action
      get(
        admin_api_position_path(999),
        headers: json_header,
      )

      # check
      not_found_response(response)
      not_found_json(json)
    end
  end
end
