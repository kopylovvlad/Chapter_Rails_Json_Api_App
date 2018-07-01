module Api
  module Chapters
    module Comments
      class ApplicationController < ApiController
        before_action :set_chapter
        before_action :set_comment
        before_action :require_user, only: %i[create destroy]

        private

        def set_chapter
          @chapter = Chapter.find(params[:chapter_id])
        end

        def set_comment
          @comment = @chapter.comments.find(params[:comment_id])
        end
      end
    end
  end
end
