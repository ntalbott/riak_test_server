require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
  t.libs << "test"
end

def build_image(version, url, latest=false)
  mkdir_p "tmp"
  sh %(DOWNLOAD_URL=#{url} VERSION=#{version} erb Dockerfile.erb > tmp/Dockerfile)
  cp %(app.config-#{version}), %(tmp/app.config)
  sh %(docker build -t ntalbott/riak_test_server:#{version} tmp)
  sh %(docker tag -f ntalbott/riak_test_server:#{version} ntalbott/riak_test_server:latest) if latest
end

task :build do
  build_image(
    "1.2",
    "http://s3.amazonaws.com/downloads.basho.com/riak/1.2/1.2.1/ubuntu/precise/riak_1.2.1-1_amd64.deb",
    true
  )
  build_image(
    "1.3",
    "http://s3.amazonaws.com/downloads.basho.com/riak/1.3/1.3.2/ubuntu/precise/riak_1.3.2-1_amd64.deb"
  )
end
