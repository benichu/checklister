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
      context   = []
      building_context = false
      checklist = []
      building_checklist = false

      @file_content.each_line do |line|
        if title == "" && line.start_with?("# ")
          title = line.sub("# ", "").sub("\n", "")
        end

        if line.start_with?("## Context")
          building_context = true
          next
        end

        if line.start_with?("## Checklist")
          building_context = false
          building_checklist = true
          next
        end

        if building_context
          context << line.sub("\n", "") unless ["", "\n"].include?(line.chomp)
        end

        if building_checklist
          checklist << line.sub("\n", "") unless ["", "\n"].include?(line.chomp)
        end
      end

      {
        title: title,
        body: "#{context.join("\n")}\n#{checklist.join("\n")}"
      }
    end
  end
end
