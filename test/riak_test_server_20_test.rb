require "minitest/autorun"
require "riak_test_server_tests"

class RiakTestServer20Test < Minitest::Test
  include RiakTestServerTests

  def version
    "2.0"
  end
end
