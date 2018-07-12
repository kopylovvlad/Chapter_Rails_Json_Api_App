# frozen_string_literal: true

##
# Api/Users/Chapters
module Api
  module Users
    class ChaptersController < Api::ApplicationController
      include Api::Users::ChaptersDoc
      resource_description { short 'Api/Users/Chapters endpoints' }

      # TODO: replace it
      before_action :set_user
      before_action :check_current_user

      def index
        @items = Searcher.new(@user.chapters.all, search_params).call
      end

      def show
        @item = @user.chapters.find(params[:id])
      end

      private

      def search_params
        params.permit(query: :title, pagination: %i[page per_page])
      end

      def set_user
        @user = User.find(params[:user_id])
      end

      def check_current_user
        return forbidden if current_user.blank? || current_user.id != @user.id
      end
    end
  end
end
