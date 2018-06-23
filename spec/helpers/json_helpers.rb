module JsonHelpers
  def success_response(response)
    expect(response.code).to eq('200')
    expect(response.content_type).to eq('application/json')
  end

  def notauth_response(response)
    expect(response.code).to eq('401')
    expect(response.content_type).to eq('application/json')
  end

  def error_response(response)
    expect(response.code).to eq('422')
    expect(response.content_type).to eq('application/json')
  end

  def forbidden_response(response)
    expect(response.code).to eq('403')
    expect(response.content_type).to eq('application/json')
  end

  def not_found_response(response)
    expect(response.code).to eq('404')
    expect(response.content_type).to eq('application/json')
  end

  def json
    JSON.parse(response.body)
  end

  def error_json
    expect(json['error']).to eq('Incorrect data')
  end

  def check_pagination(pagination)
    expect(pagination.keys.size).to eq(6)
  end

  def check_empty_pagination(pagination)
    expect(pagination['current_page']).to eq(1)
    expect(pagination['next_page']).to eq(nil)
    expect(pagination['prev_page']).to eq(nil)
    expect(pagination['first_page']).to eq(true)
    expect(pagination['last_page']).to eq(true)
    expect(pagination['total_pages']).to eq(1)
  end
end
