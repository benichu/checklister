require "checklister/configuration"
require "checklister/configuration_file"
require "checklister/issue"
require "checklister/parser"
require "checklister/sanitizer"
require "checklister/version"

# API Clients
require "checklister/client"
require "checklister/gitlab/project"
require "checklister/gitlab/issue"
require "checklister/github/project"
require "checklister/github/issue"

module Checklister
  class << self
    # Keep track of the configuration values set after a configuration
    # has been applied
    #
    # @example Return a configuration value
    #   Checklister.config.foo #=> "bar"
    #
    # @return [Object] the configuration object
    #
    def config
      @config ||= Checklister::Configuration.new
    end

    def configure(attributes = {})
      config.apply attributes
    end

    def root
      File.expand_path('../..',__FILE__)
    end
  end
end
