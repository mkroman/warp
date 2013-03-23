# encoding: utf-8

module Warp
  class Packet
    attr_accessor :attributes

    def [] key; @attributes[key] end
    def []= key, value; @attributes[key] = value end

  protected

    def pack type, object
      case type
      when :string
        [object.bytesize, object].pack 'Na*'
      when :bytes
        [object].pack 'a*'
      when :number
        [object].pack 'N'
      when :number16
        [object].pack 'n'
      when :byte
        [object].pack 'c'
      end
    end

    def unpack type, data
      case type
      when :string
        length = unpack :number, data.read(4)

        if data.size - data.pos < length
          raise "EOF?!"
        else
          contents = unpack :bytes, data.read(length)
        end

      when :number
        if data.bytesize == 2
          # Unpack a 16-bit integer.
          data.unpack(?n)[0]
        else
          # Unpack a 32-bit integer.
          data.unpack(?N)[0]
        end

      when :bytes
        data.unpack("a*")[0]
      end
    end
  end
end
