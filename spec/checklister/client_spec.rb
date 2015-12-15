require "spec_helper"
require "byebug"

describe Checklister::Client do
  let(:gitlab_config) do
    { endpoint: "https://www.gitlab.com/api", private_token: "supersecret", kind: "gitlab" }
  end

  let(:gitlab_with_certificate_config) do
    {
      endpoint: "https://www.gitlab.com/api", private_token: "supersecret", kind: "gitlab",
      endpoint_certificate_path: "#{Checklister.root}/spec/support/files/foo.crt",
      client_certificate_path: "#{Checklister.root}/spec/support/files/foo.p12",
      client_certificate_password: "client_certificate_password"
    }
  end

  let(:github_config) do
    { endpoint: "https://api.github.com", private_token: "supersecret", kind: "github" }
  end

  it "needs an implemented backend API client, based on kind" do
    expect do
      Checklister::Client.new(gitlab_config.merge!(kind: "foo"))
    end.to raise_error NotImplementedError, "No foo API client has been implemented"
  end

  context "create github API client" do
    it "initializes client" do
      github_client = Checklister::Client.new(github_config).api_client
      expect(github_client).to be_a Octokit::Client
    end

    it "removes the :endpoint option and renames :private_token into :access_token" do
      expect(Octokit::Client).to receive(:new).with(access_token: "supersecret")
      Checklister::Client.new(github_config).api_client
    end

    it "initializes a project" do
      expect(Checklister::Client.new(github_config).project).to be_a Checklister::Github::Project
    end

    it "initializes an issue" do
      expect(Checklister::Client.new(github_config).issue).to be_a Checklister::Github::Issue
    end
  end

  context "create gitlab API client" do
    context "without client certificates" do
      subject(:gitlab_client) { Checklister::Client.new(gitlab_config).api_client }

      it "initializes client" do
        expect(gitlab_client).to be_a Gitlab::Client
      end

      it "needs a valid kind option" do
        expect do
          Checklister::Client.new(gitlab_config.reject { |k| k == :kind })
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

      it "initializes a project" do
        expect(Checklister::Client.new(gitlab_config).project).to be_a Checklister::Gitlab::Project
      end

      it "initializes an issue" do
        expect(Checklister::Client.new(gitlab_config).issue).to be_a Checklister::Gitlab::Issue
      end
    end

    context "with a client certificate" do
      subject(:gitlab_client) { Checklister::Client.new(gitlab_with_certificate_config).api_client }

      it "set the ssl_ca_file" do
        expect(gitlab_client.httparty[:ssl_ca_file]).to eq(gitlab_with_certificate_config[:endpoint_certificate_path])
      end

      it "set the client certificate path" do
        expect(gitlab_client.httparty[:p12]).to eq(File.read(gitlab_with_certificate_config[:client_certificate_path]))
      end

      it "set the client certificate password" do
        expect(gitlab_client.httparty[:p12_password]).to eq(gitlab_with_certificate_config[:client_certificate_password])
      end
    end
  end
end
