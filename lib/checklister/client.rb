require "gitlab"

module Checklister
  # Implement a kind of Factory pattern
  #
  # We create an object without exposing the creation logic and then refer to newly created object using a common interface.
  class Client
    # The issue service backends we are currently supporting
    #
    #  - [x] gitlab
    #  - [ ] github
    #  - [ ] bitbucket
    #
    IMPLEMENTED_BACKENDS = %w(gitlab)

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
      raise(ArgumentError, "No #{@kind} API client has been implemented") unless IMPLEMENTED_BACKENDS.include?(@kind)
      @options = options.reject { |k| [:kind].include? k }
      default_options = { user_agent: "Checklister for #{@kind} #{Checklister::VERSION}" }
      default_options.merge!(httparty: { verify: false }) # FIXME
      @options.merge! default_options
    end

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
        ::Gitlab.client(@options)
      end
    end
  end
end
