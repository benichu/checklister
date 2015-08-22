require "spec_helper"

describe Checklister::Parser do
  let(:parser) { Checklister::Parser.new("./spec/fixtures/simple-checklist.md") }

  describe "#parse_title" do
    it "should return a parsed title" do
      expect(parser.parse_title).to eq("This is the title")
    end
  end

  describe "#parse_body" do
    it "should return a parsed body" do
      expect(parser.parse_body).to eq("This is the body")
    end
  end

  describe "#issue_params" do
    it "should assign a title" do
      expect(parser.issue_params[:title]).to_not be_nil
    end

    it "should assign a body" do
      expect(parser.issue_params[:body]).to_not be_nil
    end

    it "should return a ruby object" do
      title = parser.parse_title
      body = parser.parse_body
      expect(parser.issue_params).to include(title: title, body: body)
    end
  end
end
