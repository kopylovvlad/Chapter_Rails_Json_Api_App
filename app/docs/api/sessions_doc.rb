# frozen_string_literal: true

module Api::SessionsDoc
  extend ::Apipie::DSL::Concern

  api :GET, 'api/sessions/current', 'Show Session item'
  formats ['json']
  description 'Endpoint to see Session for admin'
  example read_file('api_sessions_show')
  error code: 404, desc: "Use only 'Accept: application/json'"
  def current; end

  api :POST, 'api/sessions', 'Create new Session'
  formats ['json']
  description 'Endpoint to create session'
  example "#{read_file('api_sessions_create_success')}\n\r\n\r#{read_file('api_sessions_create_fail')}"
  error code: 404, desc: "Use only 'Accept: application/json'"
  param :email, String, required: true
  param :password, String, required: true
  def create; end

  api :DELETE, 'api/sessions/', 'Delete Session'
  formats ['json']
  description 'Endpoint to delete Session'
  example read_file('api_sessions_show')
  error code: 404, desc: "Use only 'Accept: application/json'"
  def destroy; end
end
