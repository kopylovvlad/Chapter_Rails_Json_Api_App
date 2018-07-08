# frozen_string_literal: true

module Api::Chapters::StatesDoc
  extend ::Apipie::DSL::Concern

  api :PATCH, 'api/chapters/:chapter_id/states/on_review', 'Update State'
  formats ['json']
  description 'Update State from :draft to :in_review'
  example read_file('api_chapters_states_update_success').to_s
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 404, desc: 'Item does not exist'
  error code: 403, desc: 'User must be authenticated'
  error code: 403, desc: 'Current user must be an author'
  def on_review; end

  api :PATCH, 'api/chapters/:chapter_id/states/approved', 'Update State'
  formats ['json']
  description 'Update State from :in_review to :approved'
  example read_file('api_chapters_states_update_success').to_s
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 404, desc: 'Item does not exist'
  error code: 403, desc: 'User must be authenticated'
  error code: 403, desc: 'Current user must be an author'
  error code: 422, desc: 'many than 50% of paticipants must commented it'
  def approved; end

  api :PATCH, 'api/chapters/:chapter_id/states/published', 'Update State'
  formats ['json']
  description 'Update State from :approved to :published'
  example read_file('api_chapters_states_update_success').to_s
  error code: 404, desc: "Use only 'Accept: application/json'"
  error code: 404, desc: 'Item does not exist'
  error code: 403, desc: 'User must be authenticated'
  error code: 403, desc: 'Current user must be an author'
  def published; end
end
