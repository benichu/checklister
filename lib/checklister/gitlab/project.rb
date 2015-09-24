module Checklister
  module Gitlab
    class Project
      DEFAULT_OPTIONS = { order_by: "id", sort: "asc", per_page: "10" }

      def initialize(client)
        @client = client
      end

      def get(project_id)
        Checklister::Sanitizer.symbolize @client.project(project_id).to_hash
      end

      def all(options = {})
        query_options = DEFAULT_OPTIONS.merge options
        Checklister::Sanitizer.symbolize @client.projects(query_options).map(&:to_hash)
      end

      def filtered_by_name(name, options = {})
        query_options = DEFAULT_OPTIONS.merge options
        Checklister::Sanitizer.symbolize @client.project_search(name, query_options).map(&:to_hash)
      end
    end
  end
end
