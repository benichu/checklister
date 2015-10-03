require "spec_helper"

describe Checklister::Github::Issue do
  let(:github_config) do
    { endpoint: "https://api.github.com", private_token: "supersecret", kind: "github" }
  end
  let(:client) { Checklister::Client.new(github_config).api_client }

  describe "#create" do
    before(:each) do
      stub_request(:post, /api.github.com/).
        to_return(status: 200, body: load_fixture("github_issue"), headers: {})
    end

    context "with valid attributes" do
      it "creates an issue by calling the remote service" do
        issue = Checklister::Github::Issue.new(client).create(3, title: "Beatae possimus nostrum", body: "nihil reiciendis laboriosam nihil delectus alias accusantium dolor unde.")
        expect(JSON.parse(issue)["title"]).to eq("Found a bug")
        expect(JSON.parse(issue)["body"]).to eq("I'm having a problem with this.")
      end
    end

    context "with invalid attributes" do
    end
  end
end
