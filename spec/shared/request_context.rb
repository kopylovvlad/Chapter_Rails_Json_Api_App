RSpec.shared_context 'request_shared_context', shared_context: :metadata do
  let(:admin_user) { FactoryBot.create(:user_admin) }

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

  def not_found_json(json)
    expect(json['error']).to eq('Not found')
  end
end

RSpec.configure do |rspec|
  rspec.include_context 'request_shared_context', include_shared: true
end