module Checklister
  module Gitlab
    class Project
      # Default options that we want to pass when querying the gitlab project index
      DEFAULT_OPTIONS = { order_by: "id", sort: "asc", per_page: "10" }

      # Initialize a gitlab project instance
      #
      # @example Get a project's data
      #   project = Checklister::Project.new(gitlab_client).get(1)
      #
      # @param client [Object] an instance of Checklister::Client
      #
      def initialize(client)
        @client = client
      end

      # Query a particular project based on it's id
      # @param project_id [Integer] gitlab project id
      # @return [Hash] a project properties
      def get(project_id)
        Checklister::Sanitizer.symbolize @client.project(project_id).to_hash
      end

      # Get all gitlab's projects
      # @param options [optional, Hash] query options
      # @return [Array] and array of project's properties as Hash
      def all(options = {})
        query_options = DEFAULT_OPTIONS.merge options
        Checklister::Sanitizer.symbolize @client.projects(query_options).map(&:to_hash)
      end

      # Get gitlab's projects based on a search string (LIKE on project#name)
      # @param name [String] partial project's name
      # @param options [optional, Hash] query options
      # @return [Array] and array of project's properties as Hash
      def filtered_by_name(name, options = {})
        query_options = DEFAULT_OPTIONS.merge options
        Checklister::Sanitizer.symbolize @client.project_search(name, query_options).map(&:to_hash)
      end
    end
  end
end
