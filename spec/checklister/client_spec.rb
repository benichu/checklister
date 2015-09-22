require "spec_helper"

describe Checklister::Client do
  let(:gitlab_config) do
    { endpoint: "https://www.gitlab.com/api", private_token: "supersecret", kind: "gitlab" }
  end

  it "needs an implemented backend API client, based on kind" do
    expect do
      Checklister::Client.new(gitlab_config.merge!(kind: "foo")).get_api_client
    end.to raise_error ArgumentError, "No foo API client has been implemented"
  end

  context "create gitlab API client" do
    subject(:gitlab_client) { Checklister::Client.new(gitlab_config).get_api_client }
    it "initializes client" do
      expect(gitlab_client).to be_a Gitlab::Client
    end

    it "needs a valid kind option" do
      expect do
        Checklister::Client.new(gitlab_config.reject { |k| k == :kind }).get_api_client
      end.to raise_error ArgumentError, "No API client can be initialized"
    end

    it "sets the appropriate endpoint" do
      expect(gitlab_client.endpoint).to eq(gitlab_config[:endpoint])
    end

    it "sets the appropriate token" do
      expect(gitlab_client.private_token).to eq(gitlab_config[:private_token])
    end

    it "sets the user agent" do
      expect(gitlab_client.user_agent).to eq "Checklister for gitlab #{Checklister::VERSION}"
    end
  end
end
