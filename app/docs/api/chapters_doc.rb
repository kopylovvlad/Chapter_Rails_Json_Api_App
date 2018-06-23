# frozen_string_literal: true

module Api::ChaptersDoc
  extend ::Apipie::DSL::Concern

  api :GET, 'api/chapters', 'Get list of Chapters'
  formats ['json']
  description 'Endpoint to see Chapters for admin'
  example read_file('api_chapters_index')
  error code: 404, desc: "Use only 'Accept: application/json'"
  param :pagination, Hash do
    param :page, Integer, required: false
    param :per_page, Integer, required: false
  end
  def index; end

  api :GET, 'api/chapters/:id', 'Show Chapter item'
  formats ['json']
  description 'Endpoint to see Chapter for admin'
  example read_file('api_chapters_show')
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 404, desc: 'Item does not exist'
  def show; end

  api :POST, 'api/chapters', 'Create new Chapter'
  formats ['json']
  description 'Endpoint to create chapter'
  example "#{read_file('api_chapters_create_success')}\n\r\n\r#{read_file('api_chapters_create_fail')}"
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 422, desc: 'Params :chapters is required'
  error code: 401, desc: 'User must be auth'
  param :chapters, Hash do
    param :title, String, required: true
    param :body, Integer, required: false
  end
  def create; end

  api :PATCH, 'api/chapters/:id', 'Update Chapter'
  formats ['json']
  description 'Endpoint to update Chapter'
  example "#{read_file('api_chapters_update_success')}\n\r\n\r#{read_file('api_chapters_update_fail')}"
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 404, desc: 'Item does not exist'
  error code: 422, desc: 'Params :chapters is required'
  error code: 422, desc: 'User must be auth'
  error code: 403, desc: 'User must be the author'
  param :chapters, Hash do
    param :title, String, required: true
    param :body, Integer, required: false
  end
  def update; end

  api :DELETE, 'api/chapters/:id', 'Delete Chapter'
  formats ['json']
  description 'Endpoint to delete Chapter'
  example read_file('api_chapters_show')
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 404, desc: 'Item does not exist'
  error code: 422, desc: 'User must be auth'
  error code: 403, desc: 'User must be the author'
  def destroy; end
end
