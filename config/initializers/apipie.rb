Apipie.configure do |config|
  config.app_name                = "BookChapterApp"
  config.api_base_url            = "/"
  config.doc_base_url            = "/apipie"
  config.translate = false
  config.validate = false
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end

module Apipie::DSL::Concern
  def read_file(file_name)
    JsonYamlHelper.read_file(file_name)
  end
end
