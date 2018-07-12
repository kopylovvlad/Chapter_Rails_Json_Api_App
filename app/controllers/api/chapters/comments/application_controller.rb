# frozen_string_literal: true

module Api
  module Chapters
    module Comments
      class ApplicationController < Api::Chapters::ApplicationController
        before_action :set_comment
        before_action :require_user, only: %i[create destroy]

        private

        def set_comment
          @comment = @chapter.comments.find(params[:comment_id])
        end
      end
    end
  end
end
