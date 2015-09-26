require "spec_helper"

describe Checklister::Gitlab::Project do
  let(:gitlab_config) do
    { endpoint: "https://www.gitlab.com/api", private_token: "supersecret", kind: "gitlab" }
  end
  let(:client) { Checklister::Client.new(gitlab_config).api_client }

  describe ".get" do
    let(:project) { Checklister::Gitlab::Project.new(client).get(1) }

    before(:each) do
      stub_request(:get, /www.gitlab.com/).
        to_return(status: 200, body: load_fixture("project"), headers: {})
    end

    it "returns a valid record" do
      expect(project).to include(id: 1, name: "Checklister / Brute", description: nil)
    end
  end

  describe ".all" do
    let(:all_projects) { Checklister::Gitlab::Project.new(client).all }

    before(:each) do
      stub_request(:get, /www.gitlab.com/).
        to_return(status: 200, body: load_fixture("projects"), headers: {})
    end

    it "returns a collection of projects" do
      expect(all_projects.first[:id]).to eq 1
      expect(all_projects.last[:id]).to eq 3
    end

    it "returns a valid record" do
      project = all_projects.first
      expect(project).to include(id: 1, name: "Checklister / Brute", description: nil)
    end
  end

  describe ".filtered_by_name" do
    let(:filtered_projects) { Checklister::Gitlab::Project.new(client).filtered_by_name("git") }

    before(:each) do
      stub_request(:get, /www.gitlab.com/).
        to_return(status: 200, body: load_fixture("project_search"), headers: {})
    end

    it "returns a collection of projects" do
      expect(filtered_projects.size).to eq 1
      expect(filtered_projects.last[:id]).to eq 3
    end

    it "returns a valid record" do
      project = filtered_projects.first
      expect(project).to include(id: 3, name: "Checklister / Gitlab", description: nil)
    end
  end
end
