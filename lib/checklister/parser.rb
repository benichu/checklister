# Parse a markdown file to return an exploitable ruby object :
#   {
#     title: "Title",
#     body: "## Mardown Body context\n## Checklist\nMardown Body checklist"
#   }
#
module Checklister
  class Parser
    # Params :
    # - file : the path of the markdown file to parse
    def initialize(file_path)
      @file_content = File.open(file_path).read
    end

    # What should the issue title be ?
    # The plain text headline of the markdown document
    # Returns a string
    def parse_title
      @file_content.each_line do |line|
        if line.start_with?("# ")
          # Remove any markdown element
          # Remove extra `\n` at the end of the string if any
          return line.sub("# ", "").sub("\n", "")
          break
        end
      end
    end

    # What should the issue body be ?
    # Context (if any) + actual checklist, without the subtitles
    # Returns a string
    def parse_body
      context = get_context
      checklist = get_checklist
      "#{context}\n#{checklist}"
    end

    # Returns a ruby object, example :
    # {
    #   title: "Title",
    #   body: "## Mardown Body context\n## Checklist\nMardown Body checklist"
    # }
    def issue_params
      {
        title: parse_title,
        body: parse_body
      }
    end

    private

    def get_context
      # Find first subtitle "## Context"
      # Return the text that's between this subtitle and the next one
    end

    def get_checklist
      # Find first subtitle "## Checklist"
      # Return the text between this subtitle and the next one (same level)
      # Between each `- [ ]`, add `\n`
    end
  end
end
