module Checklister
  module Github
    class ProjectDecorator
      def initialize(object)
        @object = object
      end

      def id
        @object[:id]
      end

      def name
        @object[:full_name]
      end

      def description
        @object[:description]
      end

      def to_hash
        { id: id, name: name, description: description }
      end
    end

    class Project
      # Default options that we want to pass when querying the github project index
      DEFAULT_OPTIONS = { sort: "full_name", direction: "asc" }

      # Initialize a github project instance
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
      # @param project_id [Integer] github project id
      # @return [Hash] a project properties
      def get(project_id)
        ProjectDecorator.new(@client.repository(project_id)).to_hash
      end

      # Get all github's projects
      # @param options [optional, Hash] query options
      # @return [Array] and array of project's properties as Hash
      def all(options = {})
        query_options = DEFAULT_OPTIONS.merge options
        @client.repositories(query_options).map { |p| ProjectDecorator.new(p).to_hash }
      end

      # Get github's projects based on a search string (LIKE on project#name)
      # @param name [String] partial project's name
      # @return [Array] and array of project's properties as Hash
      def filtered_by_name(name, _options = {})
        all.select { |p| p[:name].downcase.include? name.downcase }
      end
    end
  end
end
