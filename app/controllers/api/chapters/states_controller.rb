# frozen_string_literal: true

##
# Api/Chapters/States
module Api
  module Chapters
    class StatesController < ApiController
      include Api::Chapters::StatesDoc
      resource_description { short 'Api/Chapters/States endpoints' }
      before_action :require_user
      before_action :set_chapter
      before_action :check_author

      def on_review
        @chapter = ChapterMutator.reviewing(@chapter) if @chapter.draft?
      end

      def approved
        if ChapterPolicy.able_to_approving?(@chapter)
          @chapter = ChapterMutator.approving(@chapter)
        else
          render_json_errors(
            comments: 'less than 50% of paticipants commented it'
          )
        end
      end

      def published
        @chapter = ChapterMutator.publishing(@chapter) if @chapter.approved?
      end

      private

      def set_chapter
        @chapter = Chapter.find(params[:chapter_id])
      end

      def check_author
        return forbidden unless @chapter.user_id == current_user.id
      end
    end
  end
end
