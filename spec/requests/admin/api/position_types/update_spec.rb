require 'rails_helper'

RSpec.describe 'Admin::Api::PositionTypes#update', type: :request do
  # checking roles
  include_examples(
    'guest can not :patch',
    :admin_api_position_type_path,
    FactoryBot.create(:position_type).id
  )
  include_examples(
    'applicant can not :patch',
    :admin_api_position_type_path,
    FactoryBot.create(:position_type).id
  )
  include_examples(
    'director can not :patch',
    :admin_api_position_type_path,
    FactoryBot.create(:position_type).id
  )
  include_examples(
    'certificates can not :patch',
    :admin_api_position_type_path,
    FactoryBot.create(:position_type).id
  )

  let(:item) do
    FactoryBot.create(
      :position_type,
      title: 'lololo',
      active: false,
      priority: 9
    )
  end

  describe 'admin' do
    describe 'success' do
      it 'should update item' do
        # prepare
        item
        expect(PositionType.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_position_type_path(item),
          headers: json_header,
          params: {
            position_types:
              {
                title: 'new title',
                priority: 3,
                active: true
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to eq(item.id)
        expect(json['title']).to eq('new title')
        expect(json['priority']).to eq(3)
        expect(json['active']).to eq(true)
        expect(PositionType.all.count).to eq(1)
        save_file('admin_api_position_types_update_success', json)
      end
    end

    describe 'invalid item' do
      it 'should return array with validation errors' do
        # prepare
        item
        expect(PositionType.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_position_type_path(item),
          headers: json_header,
          params: {
            position_types:
              {
                title: '',
              }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(PositionType.all.count).to eq(1)
        save_file('admin_api_position_types_update_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        item
        expect(PositionType.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_position_type_path(item),
          headers: json_header,
          params: {
            position_types: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(PositionType.all.count).to eq(1)
      end
    end

    describe 'does not exist' do
      it 'should return 404' do
        # prepare
        expect(PositionType.all.count).to eq(0)

        sign_in(admin_user)

        # action
        patch(
          admin_api_position_type_path(999),
          headers: json_header,
          params: {
            position_types: { title: '123' }
          }
        )

        # check
        not_found_response(response)
        expect(PositionType.all.count).to eq(0)
      end
    end
  end
end
