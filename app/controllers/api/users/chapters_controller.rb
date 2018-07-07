# frozen_string_literal: true

##
# Api/Users/Chapters
module Api
  module Users
    class ChaptersController < Api::Users::ApplicationController
      include Api::Users::ChaptersDoc
      resource_description { short 'Api/Users/Chapters endpoints' }

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
    end
  end
end
