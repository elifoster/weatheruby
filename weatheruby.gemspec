Gem::Specification.new do |s|
  s.authors = ['Eli Foster']
  s.name = 'weatheruby'
  s.summary = 'A Ruby gem for accessing the Weather Underground API.'
  s.version = '0.2.0'
  s.license = 'CC-BY-NC-ND-4.0'
  s.description = 'Accessing the Weather Underground API through HTTPClient.'
  s.email = 'elifosterwy@gmail.com'
  s.homepage = 'https://github.com/elifoster/weatheruby'
  s.metadata = {
    'issue_tracker' => 'https://github.com/elifoster/weatheruby/issues'
  }
  s.files = [
    'CHANGELOG.md',
    'lib/weatheruby.rb',
    'lib/weather/actions.rb'
  ]
  s.add_runtime_dependency('httpclient')
end
