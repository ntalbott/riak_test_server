# Riak Test Server

Basho has (for good reasons) discontinued support for test servers in their
client libraries, but it turns out the critical functionality is built into Riak
regardless. This project wraps some drop in code (currently just Ruby) around a
Docker container that gives the same functionality and allows rapidly resetting
the Riak backend inbetween tests.

## Pre-requisites

* [docker](https://docs.docker.com/installation/)
* A working docker host environment (I like [dvm](https://github.com/fnichol/dvm) on OS X)
* A hostname of `docker` mapped to the IP of your container host (192.168.42.43 for dvm)
* At least 1Gb available to the docker VM. The base Erlang runtime seems to be a bit of a memory hog. (`export DOCKER_MEMORY=1024` for dvm)

## Installation

Add this line to your application's Gemfile and `bundle`:

    gem 'riak_test_server'

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

* `:container_host` - hostname or IP of the container host [default: `"docker"`]
* `:http_port` - port to expose Riak HTTP on on the `container_host` [default: `"8098"`]
* `:pb_port` - port to expose Riak Protocol Buffers on on the `container_host` [default: `"8087"`]
* `:container_name` - name to use for the container when `docker run`-ing it; handy to change if you want different containers for different apps [default: `"riak_test_server"`]
* `:repository` - supplier of docker images [default: `"ntalbott/riak_test_server"`]
* `:tag` - docker image to use; `docker search ntalbott/riak_test_server` to see if other Riak versions are available [default: `"latest"`]
* `:docker_bin` - name of the docker binary [default: `"docker"`]
* `:force_restart` - will force the hard restart of any running container (slow) [efault: `false`]
