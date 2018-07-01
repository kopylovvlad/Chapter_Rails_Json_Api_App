# frozen_string_literal: true

##
# Api/Chapters/Comments/Likes
module Api
  module Chapters
    module Comments
      class LikesController < Api::Chapters::Comments::ApplicationController
        include Api::Chapters::Comments::LikesDoc
        resource_description do
          short 'Api/Chapters/Comments/Likes endpoints'
        end

        def index
          @items = Searcher.new(Chapter::Comment::Like.preload_all, search_params).call
        end

        def create
          @item = @comment.likes.new(item_params)
          if @item.valid? and @item.save
            render :show
          else
            return render_json_errors @item.errors
          end
        end

        def destroy
          @item = @comment.likes.find_by!(user_id: current_user.id)
          @item.destroy
          render :show
        end

        private

        def item_params
          {
            comment_id: @comment.id,
            user_id: current_user.id
          }
        end
      end
    end
  end
end
