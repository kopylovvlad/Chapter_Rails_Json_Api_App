# frozen_string_literal: true

class ApiController < ApplicationController
  before_action :ensure_json_request

  rescue_from Exception, with: :render_error
  rescue_from ActionController::UnknownController,
              ::AbstractController::ActionNotFound,
              ActiveRecord::RecordNotFound,
              ActionController::RoutingError, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :incorrect_data

  def not_found
    render json: {
      success: false,
      error: I18n.t('application.errors.not_found')
    }, status: :not_found
  end

  private

  def ensure_json_request
    return if request.format == :json # || request.format == :'*/*'
    render json: {
      success: false,
      error: 'Use only \'Accept: application/json\''
    }, status: 404 and return
  end

  def render_json_errors(errors = {})
    render json: { success: false, errors: errors }, status: :unprocessable_entity and return
  end

  def render_error(e)
    puts 'render_error!'
    puts e.inspect
    puts e.backtrace
    render json: {
      error: :internal_server_error
    }, status: :internal_server_error
  end

  def incorrect_data
    render json: {
      success: false,
      error: I18n.t('application.errors.incorrect_data')
    }, status: 422
  end

  def not_implemented
    render json: {
      success: false,
      error: I18n.t('application.errors.not_implemented')
    }, status: :not_implemented
  end

  def forbidden
    render json: {
      success: false,
      error: I18n.t('application.errors.incorrect_data')
    }, status: 403
  end
end
