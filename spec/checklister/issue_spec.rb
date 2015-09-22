require "spec_helper"

describe Checklister::Issue do
  let(:valid_attributes) do
    { project_id: 1, title: "My Checklist", body: "- [ ] Step 1\n- [ ] Step 2\n- [ ] Step 3" }
  end

  describe "#new" do
    it "requires a project id" do
      expect do
        Checklister::Issue.new(valid_attributes.reject { |k| k == :project_id })
      end.to raise_error(ArgumentError, "Missing project_id")
    end

    it "requires a title" do
      expect do
        Checklister::Issue.new(valid_attributes.reject { |k| k == :title })
      end.to raise_error(ArgumentError, "Missing title")
    end

    it "requires a description" do
      expect do
        Checklister::Issue.new(valid_attributes.reject { |k| k == :body })
      end.to raise_error(ArgumentError, "Missing description")
    end
  end

  context "with a valid issue" do
    subject(:issue) { Checklister::Issue.new(valid_attributes) }

    describe "#project_id" do
      it "returns a value" do
        expect(issue.project_id).to eq(valid_attributes[:project_id])
      end
    end

    describe "#title" do
      it "returns a value" do
        expect(issue.title).to eq(valid_attributes[:title])
      end
    end

    describe "#description" do
      it "returns a value" do
        expect(issue.description).to eq(valid_attributes[:body])
      end
    end
  end
end
