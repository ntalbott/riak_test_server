require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
  t.libs << "test"
end
task default: :test

def build_image(version, url, latest=false)
  mkdir_p "tmp"
  sh %(DOWNLOAD_URL=#{url} VERSION=#{version} erb Dockerfile.erb > tmp/Dockerfile)
  cp %(app.config-#{version}), %(tmp/app.config)
  sh %(docker build -t ntalbott/riak_test_server:#{version} tmp)
  sh %(docker tag -f ntalbott/riak_test_server:#{version} ntalbott/riak_test_server:latest) if latest
end

VERSIONS = {
  "1.2" => "http://s3.amazonaws.com/downloads.basho.com/riak/1.2/1.2.1/ubuntu/precise/riak_1.2.1-1_amd64.deb",
  "1.3" => "http://s3.amazonaws.com/downloads.basho.com/riak/1.3/1.3.2/ubuntu/precise/riak_1.3.2-1_amd64.deb",
  "1.4" => "http://s3.amazonaws.com/downloads.basho.com/riak/1.4/1.4.10/ubuntu/precise/riak_1.4.10-1_amd64.deb",
}

LATEST = "1.4"

task :build do
  abort "No VERSION specified" unless ENV["VERSION"]
  build_image(ENV["VERSION"], VERSIONS[ENV["VERSION"]], ENV["VERSION"] == LATEST)
end

task :build_all do
  VERSIONS.each do |version, url|
    build_image(version, url, version == LATEST)
  end
end
