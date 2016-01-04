RSpec.describe Actors::Hub do
  let(:name) { :demiurge_board }

  describe "class" do
    subject { described_class }

    describe ".new" do
      context "when good args" do
        it "returns hub" do
          expect(subject.new name).to be_instance_of described_class
        end
      end

      context "when bad args" do
        it "raises ArgumentError" do
          expect { subject.new } .to                 raise_error(ArgumentError).with_message(/\Awrong number of arguments/)
          expect { subject.new nil }.to              raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.new true }.to             raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.new "demiurge board" }.to raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
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

    describe "#actors" do
      context "when has many actors" do
        before do
          subject.actors.add(:first,  ->(message) {})
          subject.actors.add(:second, ->(message) {})
        end

        it "returns collection of actors" do
          expect(subject.actors).to be_instance_of(described_class::ActorsProxy)
          expect(subject.actors.count).to be 2
        end
      end

      context "when has one actor" do
        before { subject.actors.add(:first,  ->(message) {}) }

        it "returns collection of actors" do
          expect(subject.actors).to be_instance_of(described_class::ActorsProxy)
          expect(subject.actors.count).to be 1
        end
      end

      context "when has no actors" do
        it "returns empty collection of actors" do
          expect(subject.actors).to be_instance_of(described_class::ActorsProxy)
          expect(subject.actors.count).to be 0
        end
      end
    end
  end
end