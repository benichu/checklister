require "spec_helper"

describe Checklister::Parser do
  let(:simple_checklist) { Checklister::Parser.new("./spec/fixtures/simple-checklist.md") }
  let(:basic_checklist) { Checklister::Parser.new("./spec/fixtures/basic-checklist.md") }
  let(:complex_checklist) { Checklister::Parser.new("./spec/fixtures/complex-checklist.md") }

  context "For a default checklist" do
    before do
      @title = "Simple Checklist"
      @body = "\n## Context\n\nWhen you need to accomplish stuff, follow those steps.\n\n## Checklist\n\n- [ ] Step 1\n- [ ] Step 2\n- [ ] Step 3\n"
    end

    describe "#to_params" do
      it "should parse a title" do
        expect(simple_checklist.to_params[:title]).to eq(@title)
      end

      it "should parse a body" do
        expect(simple_checklist.to_params[:body]).to eq(@body)
      end
    end
  end

  context "For a minimal checklist" do
    before do
      @title = "Checklist"
      @body = "## Checklist without h1 title\n\n- [ ] Step 1\n- [ ] Step 2\n- [ ] Step 3\n"
    end

    describe "#to_params" do
      it "should parse a title" do
        expect(basic_checklist.to_params[:title]).to eq(@title)
      end

      it "should parse a body" do
        expect(basic_checklist.to_params[:body]).to eq(@body)
      end
    end
  end

  context "For a complex checklist" do
    before do
      @title = "DEPLOY TO A PRODUCTION SERVER"
      @body_first_context_line = "You have worked on one or many iterations of new features or bugfixes for one of our applications."
      @body_header = "## Checklist"
      @body_subheader = "### Deploy"
      @body_last_line = "- [ ] Step 3.3"
    end

    describe "#to_params" do
      it "should parse a title" do
        expect(complex_checklist.to_params[:title]).to eq(@title)
      end

      it "returns the right first line" do
        expect(complex_checklist.to_params[:body].split("\n")[3]).to eq(@body_first_context_line)
      end

      it "returns the right header" do
        expect(complex_checklist.to_params[:body].split("\n")[6]).to eq(@body_header)
      end

      it "returns the right subheader" do
        expect(complex_checklist.to_params[:body].split("\n")[14]).to eq(@body_subheader)
      end

      it "returns the right last line" do
        expect(complex_checklist.to_params[:body].split("\n").last).to eq(@body_last_line)
      end
    end
  end
end
