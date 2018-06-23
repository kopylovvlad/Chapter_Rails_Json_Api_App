json.users @items do |item|
  json.partial! 'api/shared/user', item: item
end
json.partial! 'api/shared/pagination', items: @items
