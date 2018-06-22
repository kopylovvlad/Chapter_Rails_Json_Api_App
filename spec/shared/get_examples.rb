RSpec.shared_examples 'guest can not :get' do |path_symb, *args|
  include_examples 'can not :get', nil, path_symb, args
end

RSpec.shared_examples 'applicant can not :get' do |path_symb, args|
  include_examples(
    'can not :get',
    FactoryBot.create(:user),
    path_symb,
    args
  )
end

RSpec.shared_examples 'director can not :get' do |path_symb, args|
  include_examples(
    'can not :get',
    FactoryBot.create(:user_director),
    path_symb,
    args
  )
end

RSpec.shared_examples 'certificates can not :get' do |path_symb, args|
  include_examples(
    'can not :get',
    FactoryBot.create(:user_certificates),
    path_symb,
    args
  )
end

RSpec.shared_examples 'can not :get' do |user, path_symb, args|
  it "should return forbidden at #{path_symb.inspect}" do
    # prepare
    sign_in(user) unless user.nil?

    # action
    a = send(path_symb, *args)
    get(a, headers: json_header)

    # check
    forbidden_response(response)
    expect(json['error']).to eq(I18n.t('application.errors.require_admin'))
  end
end

