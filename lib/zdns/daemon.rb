require 'daemon_spawn'

module ZDNS
  class Daemon < DaemonSpawn::Base
    def start(args)
      server = args[-1]
      server.start
      server.join
    end

    def stop
    end
  end
end
