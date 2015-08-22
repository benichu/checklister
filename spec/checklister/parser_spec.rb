require "spec_helper"

describe Checklister::Parser do
  let(:checklist_parser) { Checklister::Parser.new('./spec/fixtures/simple-checklist.md') }

  describe "#parse_title" do
    it "should return a parsed title" do
      expect(checklist_parser.parse_title).to eq("This is the title")
    end
  end

  describe "#parse_body" do
    it "should return a parsed body" do
      expect(checklist_parser.parse_body).to eq("This is the body")
    end
  end

  describe "#issue_params" do
    it "should correctly assign the title" do
      expect(checklist_parser.issue_params[:title]).to_not be_nil
    end

    it "should correctly assign the body" do
      expect(checklist_parser.issue_params[:body]).to_not be_nil
    end

    it "should return a ruby object" do
      title = checklist_parser.parse_title
      body = checklist_parser.parse_body
      expect(checklist_parser.issue_params).to include(title: title, body: body)
    end
  end
end
