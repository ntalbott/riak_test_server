require "excon"

require "riak_test_server"

module RiakTestServerTests
  def setup
    RiakTestServer.setup(server_options)
  end

  def test_clear
    response = Excon.put(put_url("1"), body: "one", headers: {"Content-Type" => "text/plain"})
    assert_equal 204, response.status, response.body
    assert_equal "one", Excon.get(get_url("1")).body

    RiakTestServer.clear
    assert_equal "not found", Excon.get(get_url("1")).body.chomp
  end

  def put_url(key)
    "http://docker:8098/buckets/a/keys/#{key}"
  end

  def get_url(key)
    "http://docker:8098/buckets/a/keys/#{key}?r=1"
  end

  def server_options
    {
      container_name: "riak_test_server_tests",
      docker_tag: version
    }
  end
end
