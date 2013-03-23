# encoding: utf-8

module Warp
  class Request < Packet
    @@transaction = 0

    def initialize target
      @id = @@transaction
      @target = target
      @attributes = {}

      @@transaction += 1
    end

    def to_s
      buffer = String.new.encode "ASCII-8BIT"

      # buffer << [0x00, @target.bytesize, @target].pack('Cna*')

      buffer.<< pack :string, @target
      buffer.<< pack :number, @id

      @attributes.each do |key, value|
        buffer.<< pack :byte, 5
        buffer.<< pack :string, key
        buffer.<< pack :string, value
        buffer.<< pack :byte, 0xFF
      end

      buffer.<< pack :byte, 0xFF
    end

    def inspect
      "#<#{self.class}: @id=#@id @target=#{@target.inspect}>"
    end
  end
end
