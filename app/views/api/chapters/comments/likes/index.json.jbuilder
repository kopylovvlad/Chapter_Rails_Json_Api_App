# frozen_string_literal: true

json.success true
json.likes @items do |item|
  json.partial! 'api/shared/like', item: item
end
json.partial! 'api/shared/pagination', items: @items
