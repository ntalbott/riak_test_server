require "minitest/autorun"
require "riak_test_server_tests"

class RiakTestServer213Test < Minitest::Test
  include RiakTestServerTests

  def version
    "2.1.3"
  end
end
