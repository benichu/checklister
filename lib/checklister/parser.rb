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

    private

    # The title should be the plain text headline of the markdown document
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

    # The body is composed of the parsed context (if any) and the checklist
    #
    # @return [String] the parsed body
    def parse_body
      "#{get_context}\n#{get_checklist}"
    end

    def get_context
      context = ""
      @file_content.each_line do |line|
        if line.start_with?("## Context")
          # Also go to next line
          next
        end
        context << line
        next
        if line.start_with?("##")
          # Means we're at the end of the Context section
          break
        end
      end
      context
    end

    def get_checklist
      checklist = ""
      @file_content.each_line do |line|
        if line.start_with?("- [ ]")
          checklist << line
        end
      end
      checklist
    end
  end
end
