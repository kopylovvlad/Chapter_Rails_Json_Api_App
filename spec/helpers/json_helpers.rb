module JsonHelpers
  def success_response(response)
    expect(response.code).to eq('200')
    expect(response.content_type).to eq('application/json')
    expect(json['success']).to eq(true)
  end

  def notauth_response(response)
    expect(response.code).to eq('401')
    expect(response.content_type).to eq('application/json')
    expect(json['success']).to eq(false)
  end

  def error_response(response)
    expect(response.code).to eq('422')
    expect(response.content_type).to eq('application/json')
    expect(json['success']).to eq(false)
  end

  def forbidden_response(response)
    expect(response.code).to eq('403')
    expect(response.content_type).to eq('application/json')
    expect(json['success']).to eq(false)
  end

  def not_found_response(response)
    expect(response.code).to eq('404')
    expect(response.content_type).to eq('application/json')
    expect(json['success']).to eq(false)
  end

  def json
    JSON.parse(response.body)
  end

  def error_json
    expect(json['error']).to eq('Incorrect data')
  end
end
