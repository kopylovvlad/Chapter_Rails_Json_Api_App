# frozen_string_literal: true

##
# template method
class Searcher
  ##
  # params has keys:
  #  :pagination:
  #     :page - Integer
  #     :per_page - Integer
  def initialize(items, params = {})
    @pagination = params[:pagination] || {}
    @params = params
    @items = items
  end

  ###
  # returns an ActiveRecord_Relation
  def call
    paginate
  end

  private

  def paginate
    @page = @pagination[:page].to_i
    @per = @pagination[:per_page].to_i

    @per = 50 if @per > 50 || @per <= 0
    @page = 1 if @page <= 0
    @items.page(@page).per(@per)
  end

  def pagination_params
    { page: 0, per_page: 0 }.merge(@pagination)
  end
end
