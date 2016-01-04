module Actors
  class Actor
    attr_reader :name

    def initialize(name, executable, publishes_to: [])
      raise ArgumentError, "'name' should be an instance of Symbol" unless name.instance_of? Symbol
      raise ArgumentError, "'executable' should be a lambda"        unless executable.instance_of?(Proc) && executable.lambda?
      raise ArgumentError, "'executable' should have arity = 1"     unless executable.arity == 1

      @name       = name
      @executable = executable
      @channels   = publishes_to
    end

    def call(message)
      raise ArgumentError, "'message' should be an instance of Hash" unless message.instance_of? Hash

      result = @executable.call(message)
      @channels.each { |channel| channel.publish result }
    end
  end
end
