require "spec_helper"

describe Checklister::Parser do
  let(:simple_checklist) { Checklister::Parser.new("./spec/fixtures/simple-checklist.md") }
  let(:basic_checklist) { Checklister::Parser.new("./spec/fixtures/basic-checklist.md") }

  context "For a default checklist" do
    before do
      @title = "Simple Checklist"
      @body = "When you need to accomplish stuff, follow those steps.\n- [ ] Step 1\n- [ ] Step 2\n- [ ] Step 3"
    end

    describe "#to_params" do
      it "should parse a title" do
        expect(simple_checklist.to_params[:title]).to eq(@title)
      end

      it "should parse a body" do
        expect(simple_checklist.to_params[:body]).to eq(@body)
      end

      it "should return a ruby object" do
        expect(simple_checklist.to_params).to include(title: @title, body: @body)
      end
    end
  end

  context "For a minimal checklist" do
    before do
      @title = ""
      @body = "\n- [ ] Step 1\n- [ ] Step 2\n- [ ] Step 3"
    end

    describe "#to_params" do
      it "should parse a title" do
        expect(basic_checklist.to_params[:title]).to eq(@title)
      end

      it "should parse a body" do
        expect(basic_checklist.to_params[:body]).to eq(@body)
      end

      it "should return a ruby object" do
        expect(basic_checklist.to_params).to include(title: @title, body: @body)
      end
    end
  end
end
