VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  # c.debug_logger = File.open(ARGV.first, 'w')
  c.cassette_library_dir = Rails.root.join("spec", "vcr")
  # c.stub_with :webmock
  c.hook_into :webmock
  c.ignore_localhost = true
  # c.filter_sensitive_data('<WSDL>') { "http://www.webservicex.net:80/uszip.asmx?WSDL" }
end

RSpec.configure do |c|
  # c.treat_symbols_as_metadata_keys_with_true_values = true
  c.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name, options) { example.call }
  end
end
