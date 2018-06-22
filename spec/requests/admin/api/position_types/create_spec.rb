require 'rails_helper'

RSpec.describe 'Admin::Api::PositionTypes#create', type: :request do
  # checking roles
  include_examples 'guest can not :post', :admin_api_position_types_path
  include_examples 'applicant can not :post', :admin_api_position_types_path
  include_examples 'director can not :post', :admin_api_position_types_path
  include_examples 'certificates can not :post', :admin_api_position_types_path

  describe 'admin' do
    describe 'success' do
      it 'should create item' do
        # prepare
        count = PositionType.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_position_types_path,
          headers: json_header,
          params: {
            position_types:
              {
                title: 'my title',
                priority: 99,
                active: false
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to_not eq(nil)
        expect(json['title']).to eq('my title')
        expect(json['priority']).to eq(99)
        expect(json['active']).to eq(false)
        expect(PositionType.all.count).to eq(count + 1)
        save_file('admin_api_position_types_create_success', json)
      end
    end

    describe 'invalid data' do
      it 'should return array with validation errors' do
        # prepare
        count = PositionType.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_position_types_path,
          headers: json_header,
          params: {
            position_types: { active: true }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(PositionType.all.count).to eq(count)
        save_file('admin_api_position_types_create_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        count = PositionType.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_position_types_path,
          headers: json_header,
          params: {
            position_types: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(PositionType.all.count).to eq(count)
      end
    end
  end
end
