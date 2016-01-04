RSpec.describe Actors::Hub::ActorsProxy do
  let(:actors)   { TypedMap.new ktype: Symbol, vtype: Actors::Actor } 
  let(:channels) { TypedMap.new ktype: Symbol, vtype: Actors::Channel }

  describe "class" do
    subject { described_class }

    describe ".new" do
      context "when good args" do
        it "returns actors proxy" do
          expect(subject.new actors, channels).to be_instance_of described_class
        end
      end

      context "when bad args" do
        it "raises ArgumentError" do
          expect { subject.new }.to                  raise_error(ArgumentError).with_message(/\Awrong number of arguments/)
          expect { subject.new nil }.to              raise_error(ArgumentError).with_message(/\Awrong number of arguments/)
          expect { subject.new nil, nil }.to         raise_error(ArgumentError).with_message("'actors' should be an instance of TypedMap")
          expect { subject.new true, nil }.to        raise_error(ArgumentError).with_message("'actors' should be an instance of TypedMap")
          expect { subject.new Hash.new, nil }.to    raise_error(ArgumentError).with_message("'actors' should be an instance of TypedMap")
          expect { subject.new actors, nil }.to      raise_error(ArgumentError).with_message("'channels' should be an instance of TypedMap")
          expect { subject.new actors, true }.to     raise_error(ArgumentError).with_message("'channels' should be an instance of TypedMap")
          expect { subject.new actors, Hash.new }.to raise_error(ArgumentError).with_message("'channels' should be an instance of TypedMap")
        end
      end
    end
  end

  describe "instance" do
    subject { described_class.new actors, channels }

    before { subject.add :registrator, ->(msg) {} }

    describe "#keys" do
      it "returns keys" do
        expect(subject.keys).to eq actors.keys
      end
    end

    describe "#[]" do
      it "returns actor" do
        expect(subject[:registrator]).to eq actors[:registrator]
      end
    end

    describe "#has?" do
      context "when has actor with given name" do
        it "returns true" do
          expect(subject.has? :registrator).to be true
        end
      end

      context "when has no actor with given name" do
        it "returns false" do
          expect(subject.has? :_registrator).to be false
        end
      end
    end

    describe "#count" do
      it "returns a number of actors" do
        expect(subject.count).to be 1
      end
    end

    describe "#length" do
      it "returns a number of actors" do
        expect(subject.length).to be 1
      end
    end

    describe "#to_a" do
      it "returns array" do
        expect(subject.to_a).to eq [[:registrator, subject[:registrator]]]
      end
    end

    describe "#to_h" do
      it "returns hash" do
        expect(subject.to_h).to eq({registrator: subject[:registrator]})
      end
    end    
  end
end
