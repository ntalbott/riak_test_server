require "minitest/autorun"
require "riak_test_server_tests"

class RiakTestServer14Test < Minitest::Test
  include RiakTestServerTests

  def version
    "1.4"
  end
end
