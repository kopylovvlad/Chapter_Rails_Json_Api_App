# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def current_user
    warden.user
  end

  private

  def require_user
    warden.authenticate!
  end

  def warden
    request.env['warden']
  end
end
