require 'daemon_spawn'

module ZDNS
  class Daemon
    class Spawn < DaemonSpawn::Base
      def start(args)
        server = args[-1]
        server.start
        server.join
      end

      def stop
      end
    end

    class << self
      def spawn!(command, config)
        config[:daemon][:application] = File.basename($0)

        if respond_to?(command)
          send(command, config)
        else
          Spawn.spawn!(config[:daemon], [command])
        end
      end

      def start(config)
        server = ZDNS::AR::Server.new(config[:server])
        server.logger = Logger.new(config[:daemon][:log_file])

        Spawn.spawn!(config[:daemon], ["start", server])
      end

      def restart(config)
        # stop
        daemons = Spawn.find(config[:daemon])
        unless daemons.empty?
          daemons.each { |d| DaemonSpawn.stop(d) }
          sleep 1
        end

        # start
        start(config)
      end
    end
  end
end
