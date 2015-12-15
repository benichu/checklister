require "gitlab"
require "octokit"

module Checklister
  # Implement a kind of Factory pattern
  #
  # We create an object without exposing the creation logic and then refer to newly created object using a common interface.
  class Client
    # The issue service backends we are currently supporting
    #
    #  - [x] gitlab
    #  - [x] github
    #  - [ ] bitbucket
    #
    IMPLEMENTED_BACKENDS = %w(gitlab github)

    attr_reader :api_client

    # Initialize all the issue service options required to be able to interact with it
    #
    # @example Initialize a gitlab client's options
    #   gitlab_client = Checklister::Client.new(kind: "gitlab", endpoint: "https://gitlab.com/api/v3", private_token: "supersecret")
    #
    # @param options [Hash] list of key/values to apply to the appropriately created API client
    # @option opts [String] :kind The issue service identifier ('github', 'gitlab', ...)
    # @option opts [String] :endpoint The issue service endpoint url
    # @option opts [String] :private_token The issue service user's private token
    #
    # @raise [ArgumentError] When no or an inexistent issue service kind is set
    #
    # @return [Object] a factory instance
    #
    def initialize(options = {})
      @kind = options.fetch(:kind) { raise ArgumentError, "No API client can be initialized" }
      raise(NotImplementedError, "No #{@kind} API client has been implemented") unless IMPLEMENTED_BACKENDS.include?(@kind)
      @options = options.reject { |k| [:kind].include? k }
      default_options = { user_agent: "Checklister for #{@kind} #{Checklister::VERSION}" }
      @options.merge! default_options
      @options_for_kind = prepare_options_for_kind(@options, @kind)
      @project_klass = nil
      @issue_klass = nil
      define_classes_for_kind(@kind)
      @api_client = get_api_client
    end

    def project
      @project ||= @project_klass.new(@api_client)
    end

    def issue
      @issue ||= @issue_klass.new(@api_client)
    end

    private

    # Initialize the issue service API client
    #
    # @example get an API client
    #   gitlab_client = Checklister::Client.new(kind: "gitlab", endpoint: "https://gitlab.com/api/v3", private_token: "supersecret")
    #   gtilab_client.get_api_client
    #
    # @return [Object] the API client based on our initialized options
    #
    def get_api_client
      case @kind
      when "gitlab"
        @api_client ||= ::Gitlab.client(@options_for_kind)
      when "github"
        @api_client ||= Octokit::Client.new(@options_for_kind)
      end
    end

    def prepare_options_for_kind(options, kind)
      httparty_options = {}
      if kind == "github"
        # Octokit uses ENV for overide
        # See: https://github.com/octokit/octokit.rb/blob/a98979107a4bf9741a05a1f751405f8a29f29b38/lib/octokit/default.rb#L136-L138
        options.delete(:user_agent)
        # :endpoint is not required
        options.delete(:endpoint)
        # :private_token is called :access_token
        options[:access_token] = options.delete(:private_token)
      elsif kind == "gitlab"
        httparty_options[:ssl_ca_file]  = options[:endpoint_certificate_path] unless options[:endpoint_certificate_path].to_s == ""
        httparty_options[:p12]          = File.read(options[:client_certificate_path]) unless options[:client_certificate_path].to_s == ""
        httparty_options[:p12_password] = options[:client_certificate_password] unless options[:client_certificate_password].to_s == ""
        options.merge!(httparty: httparty_options)
      end
      options
    end

    def define_classes_for_kind(kind)
      @project_klass = if kind == "gitlab"
                         Checklister::Gitlab::Project
                       elsif kind == "github"
                         Checklister::Github::Project
                       end
      @issue_klass = if kind == "gitlab"
                       Checklister::Gitlab::Issue
                     elsif kind == "github"
                       Checklister::Github::Issue
                     end
    end
  end
end
