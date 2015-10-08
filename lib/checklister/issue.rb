module Checklister
  class Issue
    # project_id (required) - The ID of a project
    attr_reader :project_id
    # title (required) - The title of an issue
    attr_reader :title
    # description (required) - The description of an issue
    attr_reader :description

    # Initialize an instance of Issue
    #
    # @param attributes [Hash] list of key/values
    # @return [Object] the issue object
    #
    def initialize(attributes = {})
      @project_id  = attributes.fetch(:project_id) { raise ArgumentError, "Missing project_id" }
      @title       = attributes.fetch(:title) { raise ArgumentError, "Missing title" }
      @description = attributes.fetch(:body) { raise ArgumentError, "Missing description" }
    end
  end
end
