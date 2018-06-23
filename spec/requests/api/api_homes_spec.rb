require 'rails_helper'

RSpec.describe 'Api::Home', type: :request do
  describe '404' do
    it 'should returns 404 status' do
      get(
        '/api/sdfsfasdasdasdasdadasd',
        headers: json_header
      )

      not_found_response(response)
      expect(json['error']).to eq('Not found')
    end

    it 'should always returns json' do
      get '/api/sdfsfasdasdasdasdadasd'

      not_found_response(response)
      expect(json['error']).to eq("Use only 'Accept: application/json'")
    end
  end

  describe 'root' do
    it 'shoulda return json' do
      get(
        '/',
        headers: json_header
      )

      success_response(response)
      expect(json['hello']).to eq('hello')
    end
  end
end
