# frozen_string_literal: true

##
# Api/Chapters
module Api
  # TODO: replace it!
  class ApplicationController < ApiController
    before_action :require_user, only: %i[create update destroy]
    before_action :set_item, only: %i[show update destroy]
    before_action :check_author, only: %i[update destroy]

    private

    def check_author
      return forbidden unless @item.user_id == current_user.id
    end

    def set_item
      @item = Chapter.find(params[:id])
    end
  end

  class ChaptersController < Api::ApplicationController
    include Api::ChaptersDoc
    resource_description { short 'Api/Chapters endpoints' }

    def index
      @items = Searcher.new(Chapter.not_draft, search_params).call
    end

    def show; end

    def create
      @item = Chapter.new(create_params)
      if @item.valid? and @item.save
        render :show
      else
        return render_json_errors @item.errors
      end
    end

    def update
      # TODO: system_comment
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

    def create_params
      item_params.merge(user_id: current_user.id)
    end

    def item_params
      params.require(:chapters).permit(:title, :body)
    end
  end
end
