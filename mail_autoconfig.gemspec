# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mail_autoconfig/version'

Gem::Specification.new do |spec|
  spec.name          = "mail_autoconfig"
  spec.version       = MailAutoconfig::VERSION
  spec.authors       = ["Dan Wentworth"]
  spec.email         = ["dan@atechmedia.com"]
  spec.summary       = %q{Determine configuration details for a mailbox using Mozilla's ISPDB}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.6"
  spec.add_dependency "faraday", '~> 0.9'
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'redcarpet'
end
