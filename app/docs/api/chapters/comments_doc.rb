# frozen_string_literal: true

module Api::Chapters::CommentsDoc
  extend ::Apipie::DSL::Concern

  api :GET, 'api/chapters/:chapter_id/comments', 'Get list of Comments'
  formats ['json']
  description 'Endpoint to see Comments for admin'
  example read_file('api_chapters_comments_index')
  error code: 404, desc: "Use only 'Accept: application/json'"
  param :pagination, Hash do
    param :page, Integer, required: false
    param :per_page, Integer, required: false
  end
  def index; end

  api :GET, 'api/chapters/:chapter_id/comments/:id', 'Show Comment item'
  formats ['json']
  description 'Endpoint to see Comment for admin'
  example read_file('api_chapters_comments_show')
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 404, desc: 'Item does not exist'
  def show; end

  api :POST, 'api/chapters/:chapter_id/comments', 'Create new Comment'
  formats ['json']
  description 'Endpoint to create comment'
  example "#{read_file('api_chapters_comments_create_success')}\n\r\n\r#{read_file('api_chapters_comments_create_fail')}"
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 422, desc: 'Params :comments is required'
  error code: 422, desc: 'User must be auth'
  error code: 403, desc: 'User must be the author'
  param :comments, Hash do
    param :body, String, required: true
  end
  def create; end

  api :PATCH, 'api/chapters/:chapter_id/comments/:id', 'Update Comment'
  formats ['json']
  description 'Endpoint to update Comment'
  example "#{read_file('api_chapters_comments_update_success')}\n\r\n\r#{read_file('api_chapters_comments_update_fail')}"
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 404, desc: 'Item does not exist'
  error code: 422, desc: 'Params :comments is required'
  error code: 422, desc: 'User must be auth'
  error code: 403, desc: 'User must be the author'
  param :comments, Hash do
    param :body, String, required: true
  end
  def update; end

  api :DELETE, 'api/chapters/:chapter_id/comments/:id', 'Delete Comment'
  formats ['json']
  description 'Endpoint to delete Comment'
  example read_file('api_chapters_comments_show')
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 404, desc: 'Item does not exist'
  error code: 422, desc: 'User must be auth'
  error code: 403, desc: 'User must be the author'
  def destroy; end
end
