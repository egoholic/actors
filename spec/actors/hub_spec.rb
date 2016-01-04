RSpec.describe Actors::Hub do
  describe "class" do
    subject { described_class }

    describe ".new" do
      context "when good args" do
        it "returns hub" do
          expect(subject.new :demiurge_board).to be_instance_of described_class
        end
      end

      context "when bad args" do
        it "raises ArgumentError" do
          expect { subject.new } .to                 raise_error(ArgumentError).with_message(/wrong number of arguments/)
          expect { subject.new nil }.to              raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.new true }.to             raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
          expect { subject.new "demiurge board" }.to raise_error(ArgumentError).with_message("'name' should be an instance of Symbol")
        end
      end
    end
  end
end