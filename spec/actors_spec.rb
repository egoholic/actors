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
  end
end
