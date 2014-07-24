# Riak Test Server

Basho has (for good reasons) discontinued support for test servers in their
client libraries, but it turns out the critical functionality is built into Riak
regardless. This project wraps some drop in code (currently just Ruby) around a
Docker container that gives the same functionality and allows rapidly resetting
the Riak backend inbetween tests.

## Pre-requisites

* docker
* A working docker host environment (I like dvm on OS X)
* A hostname of `docker` mapped to the IP of your container host (192.168.42.43 for dvm)

## Installation

Add this line to your application's Gemfile:

    gem 'riak_test_server'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install riak_test_server

## Usage

### Setup

Near the top of `test_helper.rb` or the like:

```
require "riak_test_server"
RiakTestServer.setup
```

### Clearing

Wherever you want to clear out Riak, say in `setup`:

```
RiakTestServer.clear
```

### Options

You can override a bunch of defaults by passing options to `RiakTestServer.setup`:

* `:container_host` [default: `"docker"`] - hostname or IP of the container host
* `:http_port` [default: `"8098"`] - port to expose Riak HTTP on on the `container_host`
* `:pb_port` [default: `"8087"`] - port to expose Riak Protocol Buffers on on the `container_host`
* `:container_name` [default: `"riak_test_server"`] - name to use for the container when `docker run`-ing it; handy to change if you want different containers for different apps
* `:repository` [default: `"ntalbott/riak_test_server"`] - supplier of docker images
* `:tag` [default: `"latest"`] - docker image to use; `docker search ntalbott/riak_test_server` to see if other Riak versions are available
* `:docker_bin` [default: `"docker"`] - name of the docker binary
