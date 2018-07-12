module Api
  module Chapters
    class ApplicationController < Api::ApplicationController
      before_action :set_chapter

      private

      def set_chapter
        @chapter = Chapter.find(params[:chapter_id])
      end
    end
  end
end
