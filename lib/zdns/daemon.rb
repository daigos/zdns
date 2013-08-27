require 'daemon_spawn'

module ZDNS
  class Daemon
    class Spawn < DaemonSpawn::Base
      def start(args)
        server = args[-1]

        [:INT, :TERM].each{|e|
          Signal.trap(e) {
            server.shutdown
          }
        }

        server.start
      end

      def stop
      end
    end

    class << self
      def spawn!(command, server)
        if respond_to?(command)
          send(command, server)
        else
          Spawn.spawn!(server.config[:daemon], [command])
        end
      end

      def start(server)
        server.logger = Logger.new(server.config[:daemon][:log_file])

        Spawn.spawn!(server.config[:daemon], ["start", server])
      end

      def restart(server)
        # stop
        daemons = Spawn.find(server.config[:daemon])
        unless daemons.empty?
          daemons.each { |d| DaemonSpawn.stop(d) }
          sleep 1
        end

        # start
        start(server)
      end
    end
  end
end
