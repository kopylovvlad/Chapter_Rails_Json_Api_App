require 'rails_helper'

RSpec.describe 'Admin::Api::Positions#create', type: :request do
  # checking roles
  include_examples 'guest can not :post', :admin_api_positions_path
  include_examples 'applicant can not :post', :admin_api_positions_path
  include_examples 'director can not :post', :admin_api_positions_path
  include_examples 'certificates can not :post', :admin_api_positions_path

  describe 'admin' do
    describe 'success' do
      it 'should create item' do
        # prepare
        count = Position.all.count
        position_type_id = FactoryBot.create(:position_type).id
        name = Faker::Lorem.word
        full_name = Faker::Lorem.words(3).join(' ')
        sign_in(admin_user)

        # action
        post(
          admin_api_positions_path,
          headers: json_header,
          params: {
            positions:
              {
                priority: 88,
                name: name,
                full_name: full_name,
                position_type_id: position_type_id,
                active: false
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to_not eq(nil)
        expect(json['priority']).to eq(88)
        expect(json['name']).to eq(name)
        expect(json['full_name']).to eq(full_name)
        expect(json['position_type_id']).to eq(position_type_id)
        expect(json['active']).to eq(false)
        expect(Position.all.count).to eq(count + 1)
        save_file('admin_api_positions_create_success', json)
      end
    end

    describe 'invalid data' do
      it 'should return array with validation errors' do
        # prepare
        count = Position.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_positions_path,
          headers: json_header,
          params: {
            positions: { active: true }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(Position.all.count).to eq(count)
        save_file('admin_api_positions_create_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        count = Position.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_positions_path,
          headers: json_header,
          params: {
            positions: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(Position.all.count).to eq(count)
      end
    end
  end
end
