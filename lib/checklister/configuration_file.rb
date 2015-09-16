require "yaml"

module Checklister
  class ConfigurationFile
    attr_reader :services

    def initialize(path)
      @path = path
      @file = load_file
      @services = load_services
    end

    def exist?
      File.exist?(@path)
    end

    def add_service(service)
      symbolized_service = Checklister::Sanitizer.symbolize(service)
      remove_service symbolized_service[:endpoint]
      @services << symbolized_service
    end

    def remove_service(endpoint)
      @services.delete_if { |h| h[:endpoint].to_s == endpoint.to_s }
    end

    def persist
      File.open(@path, "w") do |f|
        namespaced_services = { services: @services }
        f.write namespaced_services.to_yaml
      end
      reload!
    end

    def reload!
      @file = load_file
      @services = load_services
    end

    private

    def load_file
      if exist?
        Checklister::Sanitizer.symbolize YAML::load_file(@path)
      else
        {}
      end
    end

    def load_services
      if @file && @file[:services]
        @file[:services]
      else
        []
      end
    end
  end
end
