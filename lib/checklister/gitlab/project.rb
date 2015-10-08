module Checklister
  module Gitlab
    class ProjectDecorator
      def initialize(object)
        @object = object
      end

      def id
        @object.id
      end

      def name
        @object.name_with_namespace
      end

      def description
        @object.description
      end

      def to_hash
        { id: id, name: name, description: description }
      end
    end

    class Project
      # Default options that we want to pass when querying the gitlab project index
      DEFAULT_OPTIONS = { order_by: "id", sort: "asc", per_page: "100" }
      MAX_PAGES = 5

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
        ProjectDecorator.new(@client.project(project_id)).to_hash
      end

      # Get all gitlab's projects
      # @param options [optional, Hash] query options
      # @return [Array] and array of project's properties as Hash
      def all(options = {})
        query_options = DEFAULT_OPTIONS.merge options
        projects = []
        page = 1
        while page <= MAX_PAGES
          projects_per_page = @client.projects(query_options.merge(page: page))
          if projects_per_page == false || projects_per_page.empty?
            page = MAX_PAGES
            return projects
          else
            projects += projects_per_page.map { |p| ProjectDecorator.new(p).to_hash }
            page += 1
          end
        end
        projects
      end

      # Get gitlab's projects based on a search string (LIKE on project#name)
      # @param name [String] partial project's name
      # @return [Array] and array of project's properties as Hash
      def filtered_by_name(name)
        all.select { |p| p[:name].downcase.include? name.downcase }
      end
    end
  end
end
