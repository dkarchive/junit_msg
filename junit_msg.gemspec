# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'junit_msg/project'
require 'junit_msg/version'

Gem::Specification.new do |spec|
  spec.name          = JunitMsg::PROJECT
  spec.version       = JunitMsg::VERSION
  spec.authors       = ["Daniel Khamsing"]
  spec.email         = ["dkhamsing8@gmail.com"]

  spec.summary       = JunitMsg::PROJECT_DESCRIPTION
  spec.description   = JunitMsg::PROJECT_DESCRIPTION
  spec.homepage      = JunitMsg::PROJECT_URL

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = [JunitMsg::PROJECT]
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'ox', '2.8.2'
  spec.add_runtime_dependency 'colored', '1.2'
end
