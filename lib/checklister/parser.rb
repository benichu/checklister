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
    # The headline of the markdown document, minus any markdown-related caracter(# or =)
    # Returns a string
    def parse_title
      "This is the title"
    end

    # What should the issue body be ?
    # Context (if any) + actual checklist, without the subtitles
    # Returns a string
    def parse_body
      "This is the body"
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
  end
end
