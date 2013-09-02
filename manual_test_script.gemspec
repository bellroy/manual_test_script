# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'manual_test_script/version'

Gem::Specification.new do |spec|
  spec.name           = "manual_test_script"
  spec.version        = ManualTestScript::VERSION
  spec.authors        = ["Trikelings"]
  spec.email          = ["support@trikeapps.com"]
  spec.description    = %q{Manual test scripts to make sure every part which is not testable is working before deployment}
  spec.summary        = %q{Helpers to test the site manually}
  spec.homepage       = "http://trikeapps.com"
  spec.license        = 'MIT'
  spec.files          = `git ls-files`.split($/)
  spec.require_paths  = ["lib"]

  spec.add_dependency "highline"
  spec.add_dependency "treetop"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
