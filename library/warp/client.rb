# encoding: utf-8

module Warp
  class Client
    attr_accessor :sessions

    def initialize
      @sessions = []
    end

    def connect
      EventMachine.run do
        sessions.each do |session|
          session.connect unless session.connected?

        end
      end
    end
  end
end
