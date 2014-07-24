require "minitest/autorun"
require "riak_test_server_tests"

class RiakTestServer13Test < Minitest::Test
  include RiakTestServerTests

  def version
    "1.3"
  end
end
