module Checklister
  # Parse a markdown file and return the issue params.
  #
  # @example
  #   {
  #     title: "Title",
  #     body: "## Mardown Body context\n## Checklist\nMardown Body checklist"
  #   }
  #
  class Parser
    # @param [String] file_path the path of the markdown file to parse
    def initialize(file_path)
      @file_content = File.open(file_path).read
    end

    # The issue title should be the plain text headline of the markdown document
    #
    # @return [String] the parsed title
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

    # The issue body is composed of the parsed context (if any) and the checklist
    #
    # @return [String] the parsed body
    def parse_body
      context = get_context
      checklist = get_checklist
      "#{context}\n#{checklist}"
    end

    # @return [Hash] the issue params (title & body)
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
