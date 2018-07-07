# frozen_string_literal: true

module Api::Users::ChaptersDoc
  extend ::Apipie::DSL::Concern

  api :GET, 'api/users/chapters', 'Get list of Chapters'
  formats ['json']
  description 'Endpoint to see Chapters for admin'
  example read_file('api_users_chapters_index')
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 403, desc: "current_user must be an author"
  param :pagination, Hash do
    param :page, Integer, required: false
    param :per_page, Integer, required: false
  end
  def index; end

  api :GET, 'api/users/chapters/:id', 'Show Chapter item'
  formats ['json']
  description 'Endpoint to see Chapter for admin'
  example read_file('api_users_chapters_show')
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 404, desc: 'Item does not exist'
  error code: 403, desc: "current_user must be an author"
  def show; end
end
