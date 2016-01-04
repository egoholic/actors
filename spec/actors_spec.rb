RSpec.describe Actors do
  describe "module" do
    subject { described_class }

    describe ".hub" do
      context "when good args" do
        it "returns hub" do
          expect(subject.hub :demiurge_board).to be_instance_of described_class::Hub
        end
      end

      context "when bad args" do
        it "raises ArgumentError" do
          expect { subject.hub } .to                 raise_error(ArgumentError).with_message(/wrong number of arguments/)
          expect { subject.hub nil }.to              raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.hub true }.to             raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.hub "demiurge board" }.to raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
        end
      end
    end

    describe ".channel" do
      context "when good args" do
        it "returns channel" do
          expect(subject.channel :registrations).to be_instance_of(Actors::Channel)
        end
      end

      context "when bad args" do
        it "raises ArgumentError" do
          expect { subject.channel }.to               raise_error(ArgumentError).with_message(/\Awrong number of arguments/)
          expect { subject.channel nil }.to           raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.channel true }.to          raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.channel "registrator" }.to raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
        end
      end
    end

    describe ".actor" do
      context "when good args" do
        it "returns actor" do
          expect(subject.actor :registrator, ->(msg) {}).to be_instance_of Actors::Actor
        end
      end

      context "when bad args" do
        it "raises ArgumentError" do
          expect { subject.actor }.to                           raise_error(ArgumentError).with_message(/\Awrong number of arguments/)
          expect { subject.actor nil }.to                       raise_error(ArgumentError).with_message(/\Awrong number of arguments/)
          expect { subject.actor nil, nil }.to                  raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.actor true, nil }.to                 raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.actor "registrator", nil }.to        raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.actor :registrator, nil }.to         raise_error(ArgumentError).with_message("'executable' should be a lambda")
          expect { subject.actor :registrator, true }.to        raise_error(ArgumentError).with_message("'executable' should be a lambda")
          expect { subject.actor :registrator, Proc.new {} }.to raise_error(ArgumentError).with_message("'executable' should be a lambda")
          expect { subject.actor :registrator, ->() {} }.to     raise_error(ArgumentError).with_message("'executable' should have arity = 1")
          expect { subject.actor :registrator, ->(a, b) {} }.to raise_error(ArgumentError).with_message("'executable' should have arity = 1")
        end
      end
    end
  end
end
