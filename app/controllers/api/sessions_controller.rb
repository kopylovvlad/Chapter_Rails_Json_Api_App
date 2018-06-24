# frozen_string_literal: true

##
# Api/Sessions
module Api
  class SessionsController < ApiController
    include Api::SessionsDoc
    resource_description { short 'Api/Sessions endpoints' }

    def create
      require_user
      @user = current_user
      render :show
    end

    def current
      @user = current_user
      render :show
    end

    def destroy
      warden.logout
      @user = nil
      render :show
    end
  end
end
