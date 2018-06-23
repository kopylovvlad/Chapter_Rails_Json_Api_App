# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def current_user
    env['warden'].user
  end

  private

  def require_user
    env['warden'].authenticate!
  end
end
