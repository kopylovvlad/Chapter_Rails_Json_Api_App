require 'rails_helper'

RSpec.describe 'Admin::Api::districts#create', type: :request do
  # checking roles
  include_examples 'guest can not :post', :admin_api_districts_path
  include_examples 'applicant can not :post', :admin_api_districts_path
  include_examples 'director can not :post', :admin_api_districts_path
  include_examples 'certificates can not :post', :admin_api_districts_path

  describe 'admin' do
    describe 'success' do
      it 'should create item' do
        # prepare
        count = District.all.count
        sign_in(admin_user)
        param_title = Faker::Lorem.words(4).join(' ')
        params_prior = rand(100)
        division_id = FactoryBot.create(:division).id

        # action
        post(
          admin_api_districts_path,
          headers: json_header,
          params: {
            districts:
              {
                name: param_title,
                priority: params_prior,
                active: false,
                division_id: division_id
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to_not eq(nil)
        expect(json['name']).to eq(param_title)
        expect(json['priority']).to eq(params_prior)
        expect(json['active']).to eq(false)
        expect(json['division_id']).to eq(division_id)
        expect(District.all.count).to eq(count + 1)
        save_file('admin_api_districts_create_success', json)
      end
    end

    describe 'invalid data' do
      it 'should return array with validation errors' do
        # prepare
        count = District.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_districts_path,
          headers: json_header,
          params: {
            districts: { active: true }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(District.all.count).to eq(count)
        save_file('admin_api_districts_create_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        count = District.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_districts_path,
          headers: json_header,
          params: {
            districts: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(District.all.count).to eq(count)
      end
    end
  end
end
