# encoding: utf-8

module Warp
  class Session
    DefaultHost = "m.eu.wowarmory.com"
    DefaultPort = 8780

    attr_accessor :account, :password, :host, :port

    def connected?
      @connection and @connection.established?
    end

    def initialize account, password, host = DefaultHost, port = DefaultPort
      @host = host
      @port = port
      @account = account
      @password = password
    end

    def connect
      @connection = EventMachine.connect @host, @port, Connection, self
    end
  end
end
