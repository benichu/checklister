require "spec_helper"
require "tempfile"

describe Checklister::ConfigurationFile do
  let(:empty_file) { Tempfile.new(".new_checklister.yml") }
  let(:file) do
    File.new(File.join(File.dirname(__FILE__), "..", "support", "files", "checklister.yml"))
  end

  let(:valid_service_hash) do
    { endpoint: "https://www.example.com/api", private_token: "supersecret", label: "Gitlab" }
  end

  context "no file" do
    subject(:config_file) { Checklister::ConfigurationFile.new("/foo/bar/checklister.yml") }

    describe "#exist?" do
      it "is false" do
        expect(config_file.exist?).to be false
      end
    end
  end
  context "existing file" do
    subject(:config_file) { Checklister::ConfigurationFile.new(file.path) }

    describe "#exist?" do
      it "is true" do
        expect(config_file.exist?).to be true
      end
    end

    describe "#services" do
      it "is initialized with persisted services" do
        expect(config_file.services.first[:endpoint]).to eq "https://www.gitlab.com/api"
        expect(config_file.services.last[:endpoint]).to eq "https://api.github.com"
      end
    end
  end

  context "new file" do
    subject(:config_file) { Checklister::ConfigurationFile.new(empty_file.path) }

    describe "#persist" do
      it "persists the list of services" do
        config_file.add_service(valid_service_hash)
        config_file.persist
        expect(config_file.services.first[:endpoint]).to eq "https://www.example.com/api"
      end
    end

    describe "#add_service" do
      it "requires a valid service"

      it "appends a service to the list" do
        config_file.add_service(valid_service_hash)
        expect(config_file.services).to include valid_service_hash
      end

      it "updates a service when a endpoint is already defined" do
        config_file.add_service(valid_service_hash)
        updated_service = { endpoint: "https://www.example.com/api", private_token: "nosecret" }
        config_file.add_service(updated_service)
        expect(config_file.services.size).to eq 1
        expect(config_file.services.first[:endpoint]).to eq "https://www.example.com/api"
        expect(config_file.services.first[:private_token]).to eq "nosecret"
        expect(config_file.services.first[:label]).to be_nil
      end
    end

    describe "#remove_service" do
      before do
        config_file.add_service(valid_service_hash)
      end

      it "requires a endpoint as argument" do
        expect { config_file.remove_service }.to raise_error(ArgumentError)
      end

      it "removes a service from the list" do
        config_file.remove_service(valid_service_hash[:endpoint])
        expect(config_file.services).to_not include valid_service_hash
      end

      it "does not do anything if the endpoint is not found" do
        config_file.remove_service("foobar")
        expect(config_file.services).to include valid_service_hash
      end
    end
  end
end
