# frozen_string_literal: true

##
# Api/Chapters/Comments
module Api
  module Chapters
    class CommentsController < Api::Chapters::ApplicationController
      include Api::Chapters::CommentsDoc
      resource_description { short 'Api/Chapters/Comments endpoints' }

      # TODO: replace it
      before_action :require_user, only: %i[create update destroy]
      before_action :set_item, only: %i[show update destroy]
      before_action :check_comment_author, only: %i[update destroy]

      def index
        @items = Searcher.new(@chapter.comments.all, search_params).call
      end

      def show; end

      def create
        @item = Chapter::Comment.new(item_params)
        if @item.valid? and @item.save
          render :show
        else
          return render_json_errors @item.errors
        end
      end

      def update
        if @item.update(item_params)
          render :show
        else
          render_json_errors @item.errors
        end
      end

      def destroy
        @item.destroy
        render :show
      end

      private

      def item_params
        params
          .require(:comments)
          .permit(:body)
          .merge(user_id: current_user.id, chapter_id: @chapter.id)
      end

      def set_item
        @item = @chapter.comments.find(params[:id])
      end

      def check_comment_author
        return forbidden unless @item.user_id == current_user.id
      end
    end
  end
end
