require "expect"
require "timeout"

module RiakTestServer
  class Error < StandardError; end

  def self.setup(options={})
    @server.stop if @server
    @server = Server.new(options)

    @server.setup
    @server.start
    @server.check
    @server.clear
  end

  def self.clear
    @server.clear
  end

  class Server
    attr_reader :repository, :tag
    def initialize(options)
      @container_host = (options[:container_host] || "docker")
      @container_name = (options[:container_name] || "riak_test_server")
      @http_port = (options[:http_port] || "8098")
      @pb_port = (options[:pb_port] || "8087")
      @repository = (options[:docker_repository] || "ntalbott/riak_test_server")
      @tag = (options[:docker_tag] || "latest")
      @docker_bin = (options[:docker_bin] || "docker")
    end

    def start
      if docker("ps -a") =~ /\b#{@container_name}\b/
        docker "stop #{@container_name}"
        docker "rm #{@container_name}"
      end

      docker %W(
        run
        --name #{@container_name}
        --detach=true
        --interactive=true
        --publish=#{@http_port}:8098
        --publish=#{@pb_port}:8087
        #{@repository}:#{@tag}
      ).join(" ")
    end

    def stop
      @console_io.close if @console_io
      docker "stop #{@container_name}"
    end

    def setup
      unless docker("images") =~ /#{repository}\s+#{tag}/
        docker "pull #{repository}:#{tag}"
      end
    end

    def clear
      result = console("{riak_kv_memory_backend:reset(), boom}.").chomp.strip
      raise "Unable to reset backend (#{result})" unless result == "{ok,boom}"
    end

    def check
      retries = 20
      loop do
        result = console("riak_kv_console:vnode_status([]).")
        break if result.split(/^VNode: \w+$/i).size >= 4 # at least 3 vnodes are available

        raise "vnodes not starting in time" if retries == 0
        retries -= 1
        sleep 1
      end
    end

    private

    def docker(command)
      full_command = "#{@docker_bin} #{command}"
      Timeout.timeout(1) do
        `#{full_command} 2>&1`.tap do |output|
          raise "#{full_command} failed: #{output}" unless $?.exitstatus == 0
        end
      end
    rescue Timeout::Error
      raise RiakTestServer::Error, "Timed out trying to interact with Docker; is your Docker host running?"
    end

    PROMPT = /\(riak@[\w\.]+\)(\d+)>\s*/
    def console(command)
      raise "Command not terminated with a `.`: #{command}" unless command =~ /\.\s*\z/
      attach do |io|
        io.puts(command)
        response = io.expect(PROMPT, 10)
        if response
          PROMPT.match(response.first).pre_match
        else
          raise "Prompt not returned after sending #{command} to Riak console"
        end
      end
    end

    def attach
      unless @console_io
        @console_io = IO.popen([@docker_bin, "attach", @container_name], "r+", err: :out).tap{|io| io.sync = true}
        @console_io.puts("ok.")
        unless @console_io.expect(PROMPT, 10)
          raise "Unable to get a prompt on the console"
        end
      end

      yield(@console_io)
    end
  end
end
