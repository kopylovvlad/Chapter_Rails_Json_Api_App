###
# it is a helper for any request test-cases
module RequestHelpers
  def json_header
    {
      'ACCEPT' => 'application/json'
    }
  end

  def save_file(file_name, json)
    return unless ['true', true].include?(ENV['SAVE_JSON'])
    JsonYamlHelper.save_file(file_name, json)
  end
end
