# frozen_string_literal: true

module Api::RegistrationsDoc
  extend ::Apipie::DSL::Concern

  api :POST, 'api/registrations', 'Register new User'
  formats ['json']
  description 'Endpoint to create registration'
  example "#{read_file('api_registrations_create_success')}\n\r\n\r#{read_file('api_registrations_create_fail')}"
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 422, desc: 'Params :users is required'
  param :users, Hash do
    param :email, String, required: true
    param :email_confirmation, String, required: true
    param :login, String, required: true
    param :password, String, required: true
    param :password_confirmation, String, required: true
  end
  def create; end
end
