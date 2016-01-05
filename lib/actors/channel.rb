module Actors
  class Channel
    attr_reader :name, :subscribers

    def initialize(name)
      raise ArgumentError, "'name' should be an instance of Symbol" unless name.instance_of? Symbol

      @name        = name
      @queue       = Queue.new
      @threads     = ThreadGroup.new
      @mutex       = Mutex.new
      @subscribers = TypedMap.new(ktype: Symbol, vtype: Actors::Actor)

      create_threads(5)
    end

    def publish(message)
      raise ArgumentError, "'message' should be an instance of Hash" unless message.instance_of? Hash

      @queue.push message
    end

    private

    def create_threads(n)
      threads  = n.times.map do |n|
        thread = Thread.new do
          puts "thread #{n} started\n"
          loop do
            puts "thread #{n} intered to the loop\n"
            if message = @queue.pop
              puts "thread #{n} has message\n"
              puts "thread #{n} status: #{Thread.current.status}"

              @mutex.synchronize do
                subscribers.each do |s|
                  puts "--thread #{n} status: #{Thread.current.status}"
                  puts "--thread #{n} calls actor :#{s.name}"
                  s.call(message)
                end
              end

              puts "thread #{n} ends calls\n"
            end
            puts "thread #{n} ends loop\n"
          end
        end
      end

     # threads.each { |t| t.join }
    end
  end
end
