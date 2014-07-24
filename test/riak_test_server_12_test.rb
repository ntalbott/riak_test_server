require "minitest/autorun"
require "riak_test_server_tests"

class RiakTestServer12Test < Minitest::Test
  include RiakTestServerTests

  def version
    "1.2"
  end
end
