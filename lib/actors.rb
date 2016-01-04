require "actors/version"

module Actors
  require "actors/actor"
  require "actors/channel"
  require "actors/hub"

  class << self
    def hub(*args)
      Hub.new(*args)
    end
  end
end
