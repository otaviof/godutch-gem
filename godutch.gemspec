# coding: utf-8

lib_dir_path = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib_dir_path) unless $LOAD_PATH.include?(lib_dir_path)

require 'godutch/version'

Gem::Specification.new do |spec|
  spec.name = 'godutch'
  spec.version = Godutch::VERSION
  spec.authors = ['Otavio Fernandes']
  spec.email = ['otaviof@gmail.com']

  spec.summary = %q{GoDutch Ruby agent.}
  spec.description = %q{Ruby agent for GoDutch daemon based on EventMachine}
  spec.homepage = 'https://github.com/otaviof/godutch-gem'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
end

# EOF
