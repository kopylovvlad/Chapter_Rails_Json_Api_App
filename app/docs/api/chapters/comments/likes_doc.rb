# frozen_string_literal: true

module Api::Chapters::Comments::LikesDoc
  extend ::Apipie::DSL::Concern

  api :GET, 'api/chapters/:chapter_id/comments/:comment_id/likes', 'Get list of Likes'
  formats ['json']
  description 'Endpoint to see Likes for admin'
  example read_file('api_chapters_comments_likes_index')
  error code: 404, desc: "Use only 'Accept: application/json'"
  param :pagination, Hash do
    param :page, Integer, required: false
    param :per_page, Integer, required: false
  end
  def index; end

  api :POST, 'api/chapters/:chapter_id/comments/:comment_id/likes', 'Create new Like'
  formats ['json']
  description 'Endpoint to create like'
  example "#{read_file('api_chapters_comments_likes_create_success')}\n\r\n\r#{read_file('api_chapters_comments_likes_create_fail')}"
  error code: 404, desc: "Use only 'Accept: application/json'"
  def create; end

  api :DELETE, 'api/chapters/:chapter_id/comments/:comment_id/likes', 'Delete Like'
  formats ['json']
  description 'Endpoint to delete Like'
  example read_file('api_chapters_comments_likes_show')
  error code: 404, desc: "Use only 'Accept: application/json'"
  def destroy; end
end
