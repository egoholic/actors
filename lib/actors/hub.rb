module Actors
  class Hub
    def initialize(name)
      raise ArgumentError, "'name' should be an instance of Symbol" unless name.instance_of? Symbol

      @name = name
    end
  end
end
