require 'rails_helper'

RSpec.describe 'Admin::Api::Positions#update', type: :request do
  # checking roles
  include_examples(
    'guest can not :patch',
    :admin_api_position_path,
    FactoryBot.create(:position).id
  )
  include_examples(
    'applicant can not :patch',
    :admin_api_position_path,
    FactoryBot.create(:position).id
  )
  include_examples(
    'director can not :patch',
    :admin_api_position_path,
    FactoryBot.create(:position).id
  )
  include_examples(
    'certificates can not :patch',
    :admin_api_position_path,
    FactoryBot.create(:position).id
  )

  let(:item) do
    FactoryBot.create(
      :position,
      priority: 99,
      active: false
    )
  end

  describe 'admin' do
    describe 'success' do
      it 'should update item' do
        # prepare
        item
        expect(Position.all.count).to eq(1)
        new_pos_type = FactoryBot.create(:position_type)
        sign_in(admin_user)

        # action
        patch(
          admin_api_position_path(item),
          headers: json_header,
          params: {
            positions:
              {
                name: 'new name',
                full_name: 'new full name',
                priority: 3,
                active: true,
                position_type_id: new_pos_type.id
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to eq(item.id)
        expect(json['name']).to eq('new name')
        expect(json['full_name']).to eq('new full name')
        expect(json['priority']).to eq(3)
        expect(json['active']).to eq(true)
        expect(json['position_type_id']).to eq(new_pos_type.id)
        expect(Position.all.count).to eq(1)
        save_file('admin_api_positions_update_success', json)
      end
    end

    describe 'invalid item' do
      it 'should return array with validation errors' do
        # prepare
        item
        expect(Position.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_position_path(item),
          headers: json_header,
          params: {
            positions:
              {
                name: '',
              }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(Position.all.count).to eq(1)
        save_file('admin_api_positions_update_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        item
        expect(Position.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_position_path(item),
          headers: json_header,
          params: {
            positions: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(Position.all.count).to eq(1)
      end
    end

    describe 'does not exist' do
      it 'should return 404' do
        # prepare
        expect(Position.all.count).to eq(0)

        sign_in(admin_user)

        # action
        patch(
          admin_api_position_path(999),
          headers: json_header,
          params: {
            positions: { title: '123' }
          }
        )

        # check
        not_found_response(response)
        expect(Position.all.count).to eq(0)
      end
    end
  end
end
