module Actors
  class Channel
    attr_reader :name, :subscribers

    def initialize(name)
      raise ArgumentError, "'name' should be an instance of Symbol" unless name.instance_of? Symbol

      @name = name
      @subscribers = TypedMap.new(ktype: Symbol, vtype: Actors::Actor)
    end

    def publish(message)
      @subscribers.keys.each do |name|
        @subscribers[name].call message
      end
    end
  end
end
