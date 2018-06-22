RSpec.shared_examples 'guest can not :post' do |path_symb, *args|
  include_examples 'can not :post', nil, path_symb, args
end

RSpec.shared_examples 'applicant can not :post' do |path_symb, args|
  include_examples(
    'can not :post',
    FactoryBot.create(:user),
    path_symb,
    args
  )
end

RSpec.shared_examples 'director can not :post' do |path_symb, args|
  include_examples(
    'can not :post',
    FactoryBot.create(:user_director),
    path_symb,
    args
  )
end

RSpec.shared_examples 'certificates can not :post' do |path_symb, args|
  include_examples(
    'can not :post',
    FactoryBot.create(:user_certificates),
    path_symb,
    args
  )
end

RSpec.shared_examples 'can not :post' do |user, path_symb, args|
  it "should return forbidden at #{path_symb.inspect}" do
    # prepare
    sign_in(user) unless user.nil?

    # action
    a = send(path_symb, *args)
    post(a, headers: json_header, params: {})

    # check
    forbidden_response(response)
    expect(json['error']).to eq(I18n.t('application.errors.require_admin'))
  end
end

