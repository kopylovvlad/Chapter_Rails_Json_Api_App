if items.is_a?(ActiveRecord::Relation) and items.size.positive?
  json.pagination do
    json.current_page items.current_page
    json.next_page items.next_page
    json.prev_page items.prev_page
    json.first_page items.first_page?
    json.last_page items.last_page?
    json.total_pages items.total_pages
  end
else
  json.pagination do
    json.current_page 1
    json.next_page nil
    json.prev_page nil
    json.first_page true
    json.last_page true
    json.total_pages 1
  end
end
