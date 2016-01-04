module Actors
  class Hub
    class ActorsProxy
    	require "typed_map"

      def initialize(actors, channels)
        raise ArgumentError, "'actors' should be an instance of TypedMap"   unless actors.instance_of? TypedMap
        raise ArgumentError, "'channels' should be an instance of TypedMap" unless channels.instance_of? TypedMap

        @actors   = actors
        @channels = channels
      end

      def add(actor_name, executable, subscribed_on: [], publishes_to: [])
        actor = Actor.new(actor_name, executable)
        @actors.add actor.name, actor

        subscribed_on.each do |chname|
          channel = find_or_else_create_channel(chname)

          channel.subscribers.add actor.name, actor
        end

        publishes_to.each do |chname|
        	find_or_else_create_channel(chname)
        end
      end

      def keys
        @actors.keys
      end

      def [](key)
        @actors[key]
      end

      def has?(key)
        @actors.has? key
      end

      def count
        @actors.count
      end

      def length
        @actors.length
      end

      def to_a
        @actors.to_a
      end

      def to_h
        @actors.to_h
      end

      private

      def find_or_else_create_channel(chname)
        return @channels[chname] if @channels.has? chname
        
        channel = Channel.new(chname)
        @channels.add channel.name, channel

        channel
      end
    end
  end
end
