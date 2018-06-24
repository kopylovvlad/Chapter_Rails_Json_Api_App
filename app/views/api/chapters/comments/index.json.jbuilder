# frozen_string_literal: true

json.success true
json.comments @items do |item|
  json.partial! 'api/shared/comment', item: item
end
json.partial! 'api/shared/pagination', items: @items
