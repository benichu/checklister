module Checklister
  class Issue
    # - project_id (required) - The ID of a project
    # - title (required) - The title of an issue
    # - description (required) - The description of an issue
    attr_reader :project_id, :title, :description

    def initialize(attributes = {})
      @project_id  = attributes.fetch(:project_id) { raise ArgumentError, "Missing project_id" }
      @title       = attributes.fetch(:title) { raise ArgumentError, "Missing title" }
      @description = attributes.fetch(:body) { raise ArgumentError, "Missing description" }
    end
  end
end
