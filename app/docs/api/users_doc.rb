# frozen_string_literal: true

module Api::UsersDoc
  extend ::Apipie::DSL::Concern

  api :GET, 'api/users', 'Get list of Users'
  formats ['json']
  description 'Endpoint to see Users for admin'
  example read_file('api_users_index')
  error code: 404, desc: "Use only 'Accept: application/json'"
  param :pagination, Hash do
    param :page, Integer, required: false
    param :per_page, Integer, required: false
  end
  def index; end

  api :GET, 'api/users/:id', 'Show User item'
  formats ['json']
  description 'Endpoint to see User for admin'
  example read_file('api_users_show')
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 404, desc: 'Item does not exist'
  def show; end
end
