require "spec_helper"

describe Checklister::Configuration do
  subject(:config) { Checklister::Configuration.new }
  let(:valid_configuration_hash) do
    { endpoint: "https://gitlab.example.com/api/v3", private_token: "supersecret", kind: "gitlab" }
  end

  describe "#initialize" do
    it "defines a default endpoint" do
      expect(config.endpoint).to be_nil
    end

    it "defines a default private_token" do
      expect(config.private_token).to be_nil
    end

    it "defines a default label" do
      expect(config.label).to be_nil
    end

    it "defines a default kind" do
      expect(config.kind).to be_nil
    end

    it "defines a default endpoint_certificate_path" do
      expect(config.endpoint_certificate_path).to be_nil
    end

    it "defines a default client_certificate_path" do
      expect(config.client_certificate_path).to be_nil
    end

    it "defines a default client_certificate_password" do
      expect(config.client_certificate_password).to be_nil
    end
  end

  describe "#apply" do
    it "works with duplicate keys" do
      config.apply(private_token: "foo", private_token: "foo")
      expect(config.private_token).to eq("foo")
    end

    it "works with symboled and string keys" do
      config.apply(private_token: "foo", "private_token" => "foo")
      expect(config.private_token).to eq("foo")
    end

    it "applies the passed valid attributes hash" do
      config.apply(private_token: "foo")
      expect(config.private_token).to eq("foo")
    end

    it "does not apply unknown attributes" do
      expect { config.apply(foo: "bar").foo }.to raise_error(NoMethodError)
    end

    it "accepts no arguments" do
      config.apply
      expect(config.private_token).to be_nil
    end

    it "sets a label" do
      config.apply(label: "Foo")
      expect(config.label).to eq("Foo")
    end

    it "infers a label based on the given endpoint" do
      config.apply(endpoint: "https://github.com/api")
      expect(config.label).to eq("github.com")
    end

    it "sets a kind" do
      config.apply(kind: "gitlab")
      expect(config.kind).to eq("gitlab")
    end

    it "it is a valid kind"
  end

  describe "#to_hash" do
    before do
      config.apply valid_configuration_hash
    end

    it "returns a valid value with symboled keys" do
      expect(config.to_hash).to include(endpoint: valid_configuration_hash[:endpoint],
                                        private_token: valid_configuration_hash[:private_token],
                                        kind: valid_configuration_hash[:kind],
                                        endpoint_certificate_path: valid_configuration_hash[:endpoint_certificate_path],
                                        client_certificate_path: valid_configuration_hash[:client_certificate_path],
                                        client_certificate_password: valid_configuration_hash[:client_certificate_password])
    end

    it "does not return string keys" do
      expect(config.to_hash).to_not include "endpoint" => valid_configuration_hash[:endpoint]
    end
  end

  describe "#to_stdout" do
    it "is defined" do
      expect(config).to respond_to(:to_stdout)
    end

    it "is not blank" do
      expect(STDOUT).to receive(:puts).exactly(Checklister::Configuration::ATTRIBUTES.size).times
      config.to_stdout
    end

    it "returns nil" do
      expect(config.to_stdout).to be_nil
    end
  end
end
