require "spec_helper"

describe Checklister::Parser do
  let(:parser) { Checklister::Parser.new("./spec/fixtures/simple-checklist.md") }

  before do
    @title = "Simple Checklist"
    @body = "When you need to accomplish stuff, follow those steps.\n- [ ] Step 1\n- [ ] Step 2\n- [ ] Step 3"
  end

  describe "#to_params" do
    it "should parse a title" do
      expect(parser.to_params[:title]).to eq(@title)
    end

    it "should parse a body" do
      expect(parser.to_params[:body]).to eq(@body)
    end

    it "should return a ruby object" do
      expect(parser.to_params).to include(title: @title, body: @body)
    end
  end
end
