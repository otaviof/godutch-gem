# coding: utf-8

lib_dir_path = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib_dir_path) unless $LOAD_PATH.include?(lib_dir_path)

require 'godutch/version'

Gem::Specification.new do |spec|
  spec.name = 'godutch'
  spec.version = Godutch::VERSION
  spec.authors = ['Otavio Fernandes']
  spec.email = ['otaviof@gmail.com']

  spec.summary = 'GoDutch Ruby agent.'
  spec.description = 'Ruby agent for GoDutch daemon based on EventMachine'
  spec.homepage = 'https://github.com/otaviof/godutch-gem'

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(/^exe/) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(/^(test|spec|features)/)
  end

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rspec', '~> 3.3.0'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_development_dependency 'guard', '~> 2.13.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.6.4'
  spec.add_development_dependency 'terminal-notifier-guard', '~> 1.6.4'

  spec.add_dependency 'eventmachine', '~> 1.0.8'
end

# EOF
