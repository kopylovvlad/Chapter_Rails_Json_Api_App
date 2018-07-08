# frozen_string_literal: true

##
# Api/Chapters/States
class Api::Chapters::StatesController < ApiController
  include Api::Chapters::StatesDoc
  resource_description { short 'Api/Chapters/States endpoints' }
  before_action :require_user
  before_action :set_chapter
  before_action :check_author

  def on_review
    @chapter.reviewing
    # TODO: system comment
  end

  # Status can’t be changed to “approved” if less than 50% of paticipants commented on it.
  def approved
    @chapter.approving
    # TODO: validate
    # TODO: system comment
  end

  def published
    @chapter.publishing
    # TODO: system comment
  end

  private

  def set_chapter
    @chapter = Chapter.find(params[:chapter_id])
  end

  def check_author
    return forbidden unless @chapter.user_id == current_user.id
  end
end
