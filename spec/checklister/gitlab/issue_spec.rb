require "spec_helper"

describe Checklister::Gitlab::Issue do
  let(:gitlab_config) do
    { endpoint: "https://www.gitlab.com/api", private_token: "supersecret", kind: "gitlab" }
  end
  let(:client) { Checklister::Client.new(gitlab_config).api_client }
  let(:issue)  { Checklister::Gitlab::Issue.new(client).create(3, title: "Beatae possimus nostrum", body: "nihil reiciendis laboriosam nihil delectus alias accusantium dolor unde.") }

  before(:each) do
    stub_request(:post, /www.gitlab.com/).
      to_return(status: 200, body: load_fixture("issue"), headers: {})
  end

  describe "#create" do
    context "with valid attributes" do
      it "creates an issue by calling the remote service" do
        expect(issue.to_hash["project_id"]).to eq(3)
        expect(issue.to_hash["title"]).to eq("Beatae possimus nostrum")
        expect(issue.to_hash["description"]).to eq("nihil reiciendis laboriosam nihil delectus alias accusantium dolor unde.")
      end
    end
  end
end
