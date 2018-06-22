require 'rails_helper'

RSpec.describe 'Admin::Api::users#create', type: :request do
  # checking roles
  include_examples 'guest can not :post', :admin_api_users_path
  include_examples 'applicant can not :post', :admin_api_users_path
  include_examples 'director can not :post', :admin_api_users_path
  include_examples 'certificates can not :post', :admin_api_users_path

  describe 'admin' do
    describe 'success' do
      it 'should create item' do
        # prepare
        count = User.all.count
        sign_in(admin_user)
        param_title = Faker::Lorem.words(4).join(' ')
        params_prior = rand(100)

        # action
        post(
          admin_api_users_path,
          headers: json_header,
          params: {
            users:
              {
                # TODO: add attributes
                # title: param_title,
                # priority: params_prior,
                # active: false
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to_not eq(nil)
        # TODO: add attributes
        # expect(json['title']).to eq(param_title)
        # expect(json['priority']).to eq(params_prior)
        # expect(json['active']).to eq(false)
        expect(User.all.count).to eq(count + 1)
        save_file('admin_api_users_create_success', json)
      end
    end

    describe 'invalid data' do
      it 'should return array with validation errors' do
        # prepare
        count = User.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_users_path,
          headers: json_header,
          params: {
            users: { active: true }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(User.all.count).to eq(count)
        save_file('admin_api_users_create_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        count = User.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_users_path,
          headers: json_header,
          params: {
            users: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(User.all.count).to eq(count)
      end
    end
  end
end
