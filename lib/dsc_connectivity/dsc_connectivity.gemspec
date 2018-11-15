# stub: dsc_connectivity 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = 'dsc_connectivity'.freeze
  s.version = '0.1.0'

  s.required_rubygems_version = Gem::Requirement.new('>= 0'.freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { 'allowed_push_host' => "TODO: Set to 'http://mygemserver.com'" } if s.respond_to? :metadata=
  s.require_paths = ['lib'.freeze]
  s.authors = ['Thomas Statter'.freeze]
  s.bindir = 'exe'.freeze
  s.date = '2018-10-16'
  s.description = 'Connectivity library - Provides wrappers around MQ and common Mapscape message formats.'.freeze
  s.email = ['thomas.statter@mapscape.eu'.freeze]
  s.files = ['.gitignore'.freeze, '.rspec'.freeze, 'Gemfile'.freeze, 'README.md'.freeze, 'Rakefile'.freeze, 'bin/console'.freeze, 'bin/setup'.freeze, 'dsc_connectivity'.freeze, 'dsc_connectivity.gemspec'.freeze, 'lib/dsc_connectivity.rb'.freeze, 'lib/dsc_connectivity/message.rb'.freeze, 'lib/dsc_connectivity/mq/connection.rb'.freeze, 'lib/dsc_connectivity/mq/connection_factory.rb'.freeze, 'lib/dsc_connectivity/mq/logging.rb'.freeze, 'lib/dsc_connectivity/mq/publish/base.rb'.freeze, 'lib/dsc_connectivity/version.rb'.freeze]
  s.homepage = 'https://confluence.mapscape.nl/display/DSC/Data+Service+Center'.freeze
  s.rubygems_version = '2.7.6'.freeze
  s.summary = 'Data Service Center library for connectivity.'.freeze

  s.installed_by_version = '2.7.6' if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0')
      s.add_runtime_dependency('bunny'.freeze, ['>= 2.12.0'])
      s.add_development_dependency('bundler'.freeze, ['~> 1.16'])
      s.add_development_dependency('rake'.freeze, ['~> 10.0'])
      s.add_development_dependency('rspec'.freeze, ['~> 3.0'])
    else
      s.add_dependency('bundler'.freeze, ['~> 1.16'])
      s.add_dependency('bunny'.freeze, ['>= 2.12.0'])
      s.add_dependency('rake'.freeze, ['~> 10.0'])
      s.add_dependency('rspec'.freeze, ['~> 3.0'])
    end
  else
    s.add_dependency('bunny'.freeze, ['>= 2.12.0'])
    s.add_dependency('bunny'.freeze, ['>= 2.12.0'])
    s.add_dependency('rake'.freeze, ['~> 10.0'])
    s.add_dependency('rspec'.freeze, ['~> 3.0'])
  end
end
