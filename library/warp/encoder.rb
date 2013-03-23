# encoding: utf-8

module Warp
  class Encoder
    def initialize
      @objects = []
      @buffer = String.new.force_encoding "ASCII-8BIT"
    end

    def << object
      @objects << object
    end

    def encode
      @objects.map do |object|
        case object
        when String then encode_string(object)
        when Fixnum then encode_number(object)
        when Float  then encode_byte(object)
        end
      end.join
    end

  private

    def encode_string string
      [string.bytesize, string].pack 'Na*'
    end

    def encode_number number
      [number].pack 'N'
    end

    def encode_byte float
      [float.to_i].pack 'c'
    end
  end
end
