# frozen_string_literal: true

##
# Api/Users/Chapters
module Api
  module Users
    class ApplicationController < ApiController
      before_action :set_user
      before_action :check_current_user

      private

      def set_user
        @user = User.find(params[:user_id])
      end

      def check_current_user
        if current_user.blank? || current_user.id != @user.id
          return forbidden
        end
      end
    end
  end
end
