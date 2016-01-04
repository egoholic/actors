RSpec.describe Actors::Channel do
  let(:name) { :registations }
  let(:log1) { [] }
  let(:log2) { [] }
  let(:subscriber1) { Actors::Actor.new :subscriber1, ->(msg) { log1 << msg } }
  let(:subscriber2) { Actors::Actor.new :subscriber2, ->(msg) { log2 << msg } }

  describe "class" do
    subject { described_class }

    describe ".new" do
      context "when good args" do
        it "returns channel" do
          expect(subject.new name).to be_instance_of described_class
        end
      end

      context "when bad args" do
        it "raises ArgumentError" do
          expect { subject.new }.to                 raise_error(ArgumentError).with_message(/\Awrong number of arguments/)
          expect { subject.new nil }.to             raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.new true }.to            raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.new "registrations" }.to raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
        end
      end
    end
  end

  describe "instance" do
    subject { described_class.new name }

    describe "#name" do
      it "returns name" do
        expect(subject.name).to eq name
      end
    end

    describe "#subscribers" do
      context "when has many subscribers" do
        before do
          subject.subscribers.add subscriber1.name, subscriber1
          subject.subscribers.add subscriber2.name, subscriber2
        end

        it "returns subscribers collection" do
          expect(subject.subscribers).to be_instance_of TypedMap
          expect(subject.subscribers.count).to be 2
        end
      end

      context "when has one subscriber" do
        before { subject.subscribers.add subscriber1.name, subscriber1 }

        it "returns subscribers collection" do
          expect(subject.subscribers).to be_instance_of TypedMap
          expect(subject.subscribers.count).to be 1
        end
      end

      context "when has no subscribers" do
        it "returns subscribers collection" do
          expect(subject.subscribers).to be_instance_of TypedMap
          expect(subject.subscribers.count).to be 0
        end
      end
    end

    describe "#publish" do
      before do
        subject.subscribers.add subscriber1.name, subscriber1
        subject.subscribers.add subscriber2.name, subscriber2
      end

      context "when good args" do
        it "sends message to subscribers" do
          expect { subject.publish text: "some text" }
            .to change { log1 }.from([]).to([{text: "some text"}])
          expect { subject.publish text: "some text" }
            .to change { log2 }.from([{text: "some text"}]).to([{text: "some text"}, {text: "some text"}])
        end
      end

      context "when bad args" do
        it "raises ArgumentError" do
          expect { subject.publish }.to      raise_error(ArgumentError).with_message(/\Awrong number of arguments/)
          expect { subject.publish nil }.to  raise_error(ArgumentError).with_message("'message' should be an instance of Hash")
          expect { subject.publish true }.to raise_error(ArgumentError).with_message("'message' should be an instance of Hash")
          expect { subject.publish [] }.to   raise_error(ArgumentError).with_message("'message' should be an instance of Hash")
        end
      end
    end
  end
end
