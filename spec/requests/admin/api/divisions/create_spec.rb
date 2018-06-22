require 'rails_helper'

RSpec.describe 'Admin::Api::divisions#create', type: :request do
  # checking roles
  include_examples 'guest can not :post', :admin_api_divisions_path
  include_examples 'applicant can not :post', :admin_api_divisions_path
  include_examples 'director can not :post', :admin_api_divisions_path
  include_examples 'certificates can not :post', :admin_api_divisions_path

  describe 'admin' do
    describe 'success' do
      it 'should create item' do
        # prepare
        count = Division.all.count
        sign_in(admin_user)
        param_title = Faker::Lorem.words(4).join(' ')
        param_acronym = Faker::Lorem.word.split('')[1, 5].join('')
        params_prior = rand(100)

        # action
        post(
          admin_api_divisions_path,
          headers: json_header,
          params: {
            divisions:
              {
                name: param_title,
                acronym: param_acronym,
                priority: params_prior,
                active: false
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to_not eq(nil)
        expect(json['name']).to eq(param_title)
        expect(json['acronym']).to eq(param_acronym)
        expect(json['priority']).to eq(params_prior)
        expect(json['active']).to eq(false)
        expect(Division.all.count).to eq(count + 1)
        save_file('admin_api_divisions_create_success', json)
      end
    end

    describe 'invalid data' do
      it 'should return array with validation errors' do
        # prepare
        count = Division.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_divisions_path,
          headers: json_header,
          params: {
            divisions: { active: true }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(Division.all.count).to eq(count)
        save_file('admin_api_divisions_create_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        count = Division.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_divisions_path,
          headers: json_header,
          params: {
            divisions: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(Division.all.count).to eq(count)
      end
    end
  end
end
