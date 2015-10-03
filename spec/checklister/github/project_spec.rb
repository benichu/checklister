require "spec_helper"

describe Checklister::Github::Project do
  let(:github_config) do
    { endpoint: "https://api.github.com/api", private_token: "supersecret", kind: "github" }
  end
  let(:client) { Checklister::Client.new(github_config).api_client }

  describe ".get" do
    let(:project) { Checklister::Github::Project.new(client).get(1296269) }

    before(:each) do
      stub_request(:get, /api.github.com/).
        to_return(status: 200, body: load_fixture("github_project"), headers: {})
    end

    it "returns a valid record" do
      expect(project).to include(id: 1296269, name: "octocat/Hello-World", description: "This your first repo!")
    end
  end

  describe ".all" do
    let(:all_projects) { Checklister::Github::Project.new(client).all }

    before(:each) do
      stub_request(:get, /api.github.com/).
        to_return(status: 200, body: JSON.parse(load_fixture("github_projects")), headers: {})
    end

    it "returns a collection of projects" do
      expect(all_projects.first[:id]).to eq 1296269
    end

    it "returns a valid record" do
      project = all_projects.first
      expect(project).to include(id: 1296269, name: "octocat/Hello-World", description: "This your first repo!")
    end
  end

  describe ".filtered_by_name" do
    let(:filtered_projects) { Checklister::Github::Project.new(client).filtered_by_name("hello") }

    before(:each) do
      stub_request(:get, /api.github.com/).
        to_return(status: 200, body: JSON.parse(load_fixture("github_projects")), headers: {})
    end

    it "returns a collection of projects" do
      # FIXME: deal with page query
      # expect(filtered_projects.size).to eq 1
      expect(filtered_projects.last[:id]).to eq 1296269
    end

    it "returns a valid record" do
      project = filtered_projects.first
      expect(project).to include(id: 1296269, name: "octocat/Hello-World", description: "This your first repo!")
    end
  end
end
