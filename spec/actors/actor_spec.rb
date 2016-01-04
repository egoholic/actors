RSpec.describe Actors::Actor do
  let(:time)       { Time.now }
  let(:name)       { :registrator }
  let(:accounts)   { [] }
  let(:emails)     { [] }
  let :executable do
    ->(msg) { 
      result = {
        created_at: time,
        email:      msg[:email],
        password:   msg[:password]
      }

      accounts << result
      result
    }
  end

  let :actor_subscriber do
    described_class.new :registration_confirmator, ->(msg) {
      emails << {
        email:             msg[:email],
        confirmation_link: "http://example.com/confirm?token=100500xyz"
      }
    }
  end

  let :channel do
    channel = Actors::Channel.new(:registations)
    channel.subscribers.add actor_subscriber.name, actor_subscriber
    channel
  end

  describe "class" do
    subject { described_class }

    describe ".new" do
      context "when good args" do
        it "returns actor" do
          expect(subject.new name, executable).to be_instance_of described_class
          expect(subject.new name, executable, publishes_to: [channel]).to be_instance_of described_class
        end
      end

      context "when bad args" do
        it "raises ArgumentError" do
          expect { subject.new }.to                     raise_error(ArgumentError).with_message(/wrong number of arguments/)
          expect { subject.new nil }.to                 raise_error(ArgumentError).with_message(/wrong number of arguments/)
          expect { subject.new nil, nil }.to            raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.new true, nil }.to           raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.new "registrator", nil }.to  raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.new name, nil }.to           raise_error(ArgumentError).with_message("'executable' should be a lambda")
          expect { subject.new name, true }.to          raise_error(ArgumentError).with_message("'executable' should be a lambda")
          expect { subject.new name, "registrator" }.to raise_error(ArgumentError).with_message("'executable' should be a lambda")
          expect { subject.new name, {} }.to            raise_error(ArgumentError).with_message("'executable' should be a lambda")
          expect { subject.new name, Proc.new {} }.to   raise_error(ArgumentError).with_message("'executable' should be a lambda")
          expect { subject.new name, ->() {} }.to       raise_error(ArgumentError).with_message("'executable' should have arity = 1")
          expect { subject.new name, ->(a, b) {} }.to   raise_error(ArgumentError).with_message("'executable' should have arity = 1")
        end
      end
    end
  end

  describe "instance" do
    subject { described_class.new name, executable, publishes_to: [channel] }

    describe "#name" do
      it "returns name" do
        expect(subject.name).to eq name
      end
    end

    describe "#call" do
      context "when good args" do
        it "executes executable" do
          expect { subject.call(email: "user@example.com", password: "12345678") }
            .to change { accounts }.from([]).to([{created_at: time, email: "user@example.com", password: "12345678"}])
        end

        it "publishes result to channels" do
          expect { subject.call(email: "user@example.com", password: "12345678") }
            .to change { emails }.from([]).to([{email: "user@example.com", confirmation_link: "http://example.com/confirm?token=100500xyz"}])
        end
      end

      xcontext "when bad args" do
        it "raises ArgumentError" do

        end
      end
    end
  end
end
