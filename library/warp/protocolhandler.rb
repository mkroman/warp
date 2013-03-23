# encoding: utf-8

module Warp
  class ProtocolHandler < EventMachine::Connection
    def initialize
      @size = 0
      @state = :ready
      @buffer = String.new.force_encoding "ASCII-8BIT"

      super
    end

    def receive_data data
      @buffer << data

      case @state
      when :ready
        unless @buffer.size < 4
          @size = response_size + 4

          if @buffer.size < @size
            @state = :waiting
          else
            read_response
          end
        end
      when :waiting
        unless @buffer.size < @size
          @state = :ready

          read_response
        end
      end
    end

    def receive_response response
    end

  protected

    def read_response
      @state = :ready
      response = Response.parse @buffer.slice! 0...@size 

      receive_response response
    end

    def response_size
      data = @buffer.slice 0...4

      return data.unpack(?N).first
    end
  end
end
