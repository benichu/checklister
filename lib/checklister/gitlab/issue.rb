module Checklister
  module Gitlab
    class Issue
      def initialize(client)
        @client = client
      end

      def create(project_id, attributes = {})
        issue = Checklister::Issue.new(attributes.merge(project_id: project_id))
        @client.create_issue(issue.project_id, issue.title, description: issue.description)
      end
    end
  end
end
