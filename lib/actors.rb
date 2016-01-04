require "actors/version"

module Actors
  require "actors/actor"
  require "actors/channel"
  require "actors/hub"

  class << self
    def hub(*args)
      Hub.new(*args)
    end

    def channel(*args)
      Channel.new(*args)
    end

    def actor(*args)
      Actor.new(*args)
    end
  end
end
