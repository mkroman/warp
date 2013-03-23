# encoding: utf-8

require 'date'
require 'socket'

module Warp
  class Connection < ProtocolHandler
    include Logging

    def established?; @connected == true end

    def initialize session
      @session = session
      @connected = false

      super()
    end

    def connection_completed
      log.info "Connected to #{@session.host ^ :yellow} …"

      srp = SRP::Client.new
      challenge_a_hex = srp.start_authentication
      challenge_a = challenge_a_hex.dup.force_encoding("ASCII-8BIT").scan(/../).map{|m| m.to_i(16).chr }.join

      log.debug "Challenge A: #{challenge_a_hex[0..64]}… (#{challenge_a.bytesize.to_s ^ :bold} bytes.)"

      request = Request.new "/authenticate1"
      request["screenRes"] = "PHONE_MEDIUM"
      request["device"] = "iPhone"
      request["deviceSystemVersion"] = "4.0"
      request["deviceModel"] = "iPod2,1"
      request["appV"] = "3.0.0"
      request["deviceTime"] = Time.now.to_i.to_s
      request["deviceTimeZoneId"] = "Europe/Berlin"
      request["clientA"] = challenge_a
      request["appId"] = "Armory"
      request["emailAddress"] = @session.account
      request["deviceTimeZone"] = "7200000"
      request["locale"] = "en_GB"

      transmit request
    end

    def receive_response response
      log.info "Received response #{response.inspect}"
    end

    def transmit request
      send_data request.to_s
      log "#{'→' ^ :green} #{request.inspect}"
    end
  end
end
