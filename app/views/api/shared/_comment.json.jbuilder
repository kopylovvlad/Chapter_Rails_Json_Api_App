# frozen_string_literal: true

json.id item.id
json.body item.body
json.user_id item.user_id
json.chapter_id item.chapter_id
json.created_at l item.created_at.in_time_zone
json.updated_at l item.updated_at.in_time_zone
