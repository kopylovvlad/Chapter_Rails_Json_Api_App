# frozen_string_literal: true

json.success true
json.chapters @items do |item|
  json.partial! 'api/shared/chapter', item: item
end
json.partial! 'api/shared/pagination', items: @items
