##
# how to use:
#
# save json to a file
# JsonYamlHelper.save_file('home_example', json)
#
# read json from a file
#
# JsonYamlHelper.read_file('home_example')
module JsonYamlHelper
  def self.save_file(file_path, json)
    json = JSON.parse(json) if json.is_a?(String)

    File.open(
      "#{Rails.root}/docs/json_examples/#{file_path}.yml",
      'w'
    ) do |file|
      file.puts YAML::dump(json)
    end
    true
  rescue => e
    puts e.inspect
    false
  end

  def self.read_file(file_path)
    file = File.open(
      "#{Rails.root}/docs/json_examples/#{file_path}.yml",
      'r'
    )
    raw = JSON.generate(YAML::load(file.read))
    JSON.pretty_generate(JSON.parse(raw)) # for pretty
  rescue => e
    puts e.inspect
    ''
  end
end
