module Actors
  class Hub
    require "typed_map"
    require "actors/hub/actors_proxy"

    attr_reader :name

    def initialize(name)
      raise ArgumentError, "'name' should be an instance of Symbol" unless name.instance_of? Symbol

      @name         = name
      @actors       = TypedMap.new(ktype: Symbol, vtype: Actors::Actor)
      @channels     = TypedMap.new(ktype: Symbol, vtype: Actors::Channel)
      @actors_proxy = ActorsProxy.new(@actors, @channels)
    end

    def actors
      @actors_proxy
    end
  end
end
