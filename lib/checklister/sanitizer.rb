module Checklister
  class Sanitizer
    def self.symbolize(obj)
      return obj.inject({}) do |memo, (k, v)|
        memo.tap { |m| m[k.to_sym] = symbolize(v) }
      end if obj.is_a? Hash

      return obj.inject([]) do |memo, v|
        memo << symbolize(v)
        memo
      end if obj.is_a? Array

      obj
    end
  end
end
