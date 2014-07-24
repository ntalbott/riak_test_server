# coding: utf-8
lib = File.expand_path('../ruby', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'riak_test_server/version'

Gem::Specification.new do |spec|
  spec.name          = "riak_test_server"
  spec.version       = RiakTestServer::VERSION
  spec.authors       = ["Nathaniel Talbott"]
  spec.email         = ["nathaniel@talbott.ws"]
  spec.summary       = %q{A drop-in Riak test server. Uses Docker.}
  spec.homepage      = "https://github.com/ntalbott/riak_test_server"
  spec.license       = "MIT"

  spec.files         = %w(
    ruby/riak_test_server.rb
    ruby/riak_test_server/version.rb
    LICENSE.txt
    README.md
  )
  spec.require_paths = ["ruby"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "excon"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "erubis"
end
