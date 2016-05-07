Gem::Specification.new do |s|
  s.authors = ['Eli Foster']
  s.name = 'weatheruby'
  s.summary = 'A Ruby gem for accessing the Weather Underground API.'
  s.version = '0.6.0'
  s.license = 'MIT'
  s.description = 'Accessing the Weather Underground API through HTTPClient.'
  s.email = 'elifosterwy@gmail.com'
  s.homepage = 'https://github.com/elifoster/weatheruby'
  s.metadata = {
    'issue_tracker' => 'https://github.com/elifoster/weatheruby/issues'
  }
  s.files = [
    'CHANGELOG.md',
    'LICENSE.md',
    'lib/weatheruby.rb',
    'lib/weather/actions.rb',
    'lib/weather/planner.rb'
  ]
  s.executables = 'weatheruby'
  s.add_runtime_dependency('httpclient', '~> 2.8')
  s.add_runtime_dependency('rainbow', '~> 2.1')
  s.add_runtime_dependency('string-utility', '~> 2.7')
end
