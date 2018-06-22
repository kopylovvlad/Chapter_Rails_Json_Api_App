require 'rails_helper'

RSpec.describe 'Admin::Api::specialities#create', type: :request do
  # checking roles
  include_examples 'guest can not :post', :admin_api_specialities_path
  include_examples 'applicant can not :post', :admin_api_specialities_path
  include_examples 'director can not :post', :admin_api_specialities_path
  include_examples 'certificates can not :post', :admin_api_specialities_path

  describe 'admin' do
    describe 'success' do
      it 'should create item' do
        # prepare
        count = Speciality.all.count
        sign_in(admin_user)
        param_title = Faker::Lorem.words(4).join(' ')
        param_title2 = Faker::Lorem.words(2).join(' ')
        params_prior = rand(100)
        position_id = FactoryBot.create(:position).id

        # action
        post(
          admin_api_specialities_path,
          headers: json_header,
          params: {
            specialities:
              {
                position_id: position_id,
                name: param_title,
                genitive_name: param_title2,
                priority: params_prior,
                active: false
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to_not eq(nil)
        expect(json['position_id']).to eq(position_id)
        expect(json['name']).to eq(param_title)
        expect(json['genitive_name']).to eq(param_title2)
        expect(Speciality.all.count).to eq(count + 1)
        save_file('admin_api_specialities_create_success', json)
      end
    end

    describe 'invalid data' do
      it 'should return array with validation errors' do
        # prepare
        count = Speciality.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_specialities_path,
          headers: json_header,
          params: {
            specialities: { active: true }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(Speciality.all.count).to eq(count)
        save_file('admin_api_specialities_create_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        count = Speciality.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_specialities_path,
          headers: json_header,
          params: {
            specialities: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(Speciality.all.count).to eq(count)
      end
    end
  end
end
