# frozen_string_literal: true

json.id item.id
json.user do
  json.partial! 'api/shared/user', item: item.user
end
json.user_id item.user_id
json.comment_id item.comment_id
json.created_at l item.created_at.in_time_zone
json.updated_at l item.updated_at.in_time_zone
