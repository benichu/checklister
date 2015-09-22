module Checklister
  # Parse a markdown file and return a hash of params.
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

    # @return [Hash] a hash of params
    def to_params
      title     = ""
      checklist = []

      @file_content.each_line do |line|
        # Extract a title, when we find the first <h1> header
        if title == "" && line.start_with?("# ")
          title = line.sub("# ", "").sub("\n", "")
        else
          # Then, keep the text intact until the end of the file
          checklist << line
        end
      end

      # Default title, if no <H1> header found
      title = "Checklist" if title == ""

      # Return the parsed text as an object
      { title: title, body: checklist.join }
    end
  end
end
