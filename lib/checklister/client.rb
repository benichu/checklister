require "gitlab"

module Checklister
  class Client
    IMPLEMENTED_BACKENDS = %w(gitlab)

    def initialize(options = {})
      @kind = options.fetch(:kind) { raise ArgumentError, "No API client can be initialized" }
      raise(ArgumentError, "No #{@kind} API client has been implemented") unless IMPLEMENTED_BACKENDS.include?(@kind)
      @options = options.reject { |k| [:kind].include? k }
      default_options = { user_agent: "Checklister for #{@kind} #{Checklister::VERSION}" }
      default_options.merge!(httparty: { verify: false }) # FIXME
      @options.merge! default_options
    end

    def get_api_client
      case @kind
      when "gitlab"
        ::Gitlab.client(@options)
      end
    end
  end
end
