# encoding: utf-8

module Warp
  class Response < Packet
    attr_accessor :size, :status, :target, :id

    def self.parse data
      buffer = StringIO.new data

      new buffer
    end

    def initialize buffer
      @buffer = buffer
      @attributes = {}

      parse
    end

  private

    def parse
      @size   = unpack :number, @buffer.read(4)
      @status = unpack :number, @buffer.read(2)
      @target = unpack :string, @buffer
      @id     = unpack :number, @buffer.read(4)

      clear
    end

    def parse_body
      unless at_end?
        
      end
    end

    def at_end?
      @buffer.size > @buffer.pos
    end

    def clear
      if @buffer.close
        @buffer = nil
      end
    end
  end
end
