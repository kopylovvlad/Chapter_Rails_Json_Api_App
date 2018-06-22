require 'rails_helper'

RSpec.describe 'Admin::Api::MaritalStatuses#update', type: :request do
  # checking roles
  include_examples(
    'guest can not :patch',
    :admin_api_marital_status_path,
    FactoryBot.create(:marital_status).id
  )
  include_examples(
    'applicant can not :patch',
    :admin_api_marital_status_path,
    FactoryBot.create(:marital_status).id
  )
  include_examples(
    'director can not :patch',
    :admin_api_marital_status_path,
    FactoryBot.create(:marital_status).id
  )
  include_examples(
    'certificates can not :patch',
    :admin_api_marital_status_path,
    FactoryBot.create(:marital_status).id
  )

  let(:item) do
    FactoryBot.create(
      :marital_status,
      name: 'lololo',
      active: false,
      priority: 9
    )
  end

  describe 'admin' do
    describe 'success' do
      it 'should update item' do
        # prepare
        item
        expect(MaritalStatus.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_marital_status_path(item),
          headers: json_header,
          params: {
            marital_statuses:
              {
                name: 'new name',
                priority: 3,
                active: true
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to eq(item.id)
        expect(json['name']).to eq('new name')
        expect(json['priority']).to eq(3)
        expect(json['active']).to eq(true)
        expect(MaritalStatus.all.count).to eq(1)
        save_file('admin_api_marital_statuses_update_success', json)
      end
    end

    describe 'invalid item' do
      it 'should return array with validation errors' do
        # prepare
        item
        expect(MaritalStatus.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_marital_status_path(item),
          headers: json_header,
          params: {
            marital_statuses:
              {
                name: '',
              }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(MaritalStatus.all.count).to eq(1)
        save_file('admin_api_marital_statuses_update_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        item
        expect(MaritalStatus.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_marital_status_path(item),
          headers: json_header,
          params: {
            marital_statuses: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(MaritalStatus.all.count).to eq(1)
      end
    end

    describe 'does not exist' do
      it 'should return 404' do
        # prepare
        expect(MaritalStatus.all.count).to eq(0)

        sign_in(admin_user)

        # action
        patch(
          admin_api_marital_status_path(999),
          headers: json_header,
          params: {
            marital_statuses: { name: '123' }
          }
        )

        # check
        not_found_response(response)
        expect(MaritalStatus.all.count).to eq(0)
      end
    end
  end
end
