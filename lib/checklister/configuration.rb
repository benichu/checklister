require "uri"

module Checklister
  # This class maintains all system-wide configuration for *checklister*. It properly
  # applies the correct source of configuration values based on the different contexts and
  # also makes sure that compulsory data are not missing.
  #
  # Some values are dependent on a context, for example: `host` can have different values
  # based on what service the user wants to connect to.
  # Other values are shared by all those contexts, for example `log_file` is defined once and
  # for all and the service selected by our user does not matter.
  #
  # *checklister* can work with several publishing destinations, for example:
  #
  # - [gitlab.com](https://gitlab.com/) (Official Hosted Service)
  # - privately hosted _gitlab_ server
  # - [github.com](https://github.com/)
  #
  # ## Setting/Selecting the configuration values
  #
  # When using the *checklister* binary, you can set one of the many publishing destinations
  # you have access to, via two possible ways:
  #
  # ### 1. CLI Configuration Values
  #
  # No configuration file required, you can pass your service credentials directly inline as options.
  #
  # For example, you might do:
  #
  # ```bash
  # $ checklister --endpoint=https://api.github.com --private_token==supersecret create ...
  # ```
  # NOTE: Every time you pass credentials via command line options, they will override any configuration
  # file you have previously set .
  #
  # ### 2. Configuration File
  #
  # You can use the command line to add publishing destinations credentials and answer the questions:
  #
  # ```bash
  # $ checklister setup
  # ```
  #
  # By default, that configuration file will be saved at `/path/to/home/.checklister.json`.
  # But you can easily use another one by using that option before any *checklister* commands:
  #
  # ```bash
  # $ checklister --config=/another/path/to/my_checklister.json setup
  # ```
  # As soon as you have set up one or many publishing destinations, every time you will be using
  # a *checklister* command you will be prompted to select which service to use, for example:
  #
  # ```bash
  # $ checklister create ...
  #
  #   Select which service to use:
  #   [1] https://github.com/benichu
  #   [2] https://github.com/mdeloupy
  #   [3] https://gitlab.intello.com
  # ```
  #
  # ## DEVELOPMENT: Using the configuration values
  #
  # Any time you need to access the credentials, you just need to confidently query the value without
  # worrying about the context selected by the user.
  #
  # For example:
  #
  # - The user selected the `https://github.com/benichu` service, querying `Checklister.config.username` will return the appropriate value `github_user`
  # - But, if the user selects next the `https://gitlab.intello.com` service, querying `Checklister.config.username` will return the appropriate value `gitlab_user`
  #
  class Configuration
    # List of all the configuration attributes stored for use within the gem
    ATTRIBUTES = [:endpoint, :private_token, :label]

    # List of accessor attributes
    attr_accessor :endpoint, :private_token
    # List of writer attributes (with a reader defined in the class definition)
    attr_writer :label

    # Apply a configuration hash to a configuration instance
    #
    # @example Override one of the configuration attributes
    #   config = Checklister::Configuration.new
    #   config.apply(private_token: 'supersecret')
    #   config.private_token #=> "supersecret"
    #
    # @param attributes [Hash] list of key/values to apply to the configuration
    # @return [Object] the configuration object
    #
    def apply(attributes = {})
      prepared_attributes = prepare_attributes attributes
      prepared_attributes.each_pair do |attribute, value|
        send("#{attribute}=", value)
      end
      self
    end

    # The label value, if not specifically set, we infer it from the given
    # endpoint url (we use the host)
    #
    # @return [String] the label string
    #
    def label
      if instance_variable_get "@label"
        @label
      elsif instance_variable_get "@endpoint"
        URI.parse(@endpoint).host
      end
    end

    # The configuration instance formatted as a stringified hash
    #
    # @example Override one of the configuration attributes
    #   config = Checklister::Configuration.new
    #   config.to_hash #=> { "endpoint" => "https://gitlab.example.com/api/v3", ..., "private_token" => "supersecret" }
    #
    # @return [Hash] the configuration object as a Hash
    #
    def to_hash
      ATTRIBUTES.inject({}) do |hash, attr|
        hash["#{attr}"] = instance_variable_get("@#{attr}")
        hash
      end
    end

    # Write a configuration summary to STDOUT, useful for output in the CLI
    #
    def to_stdout
      to_hash.each_pair do |attribute, value|
        puts "%-20s %-50s" % ["#{attribute}:", value]
      end
      nil
    end

    private

    # Symbolize keys and remove nil or duplicate attributes
    # The attributes usually passed to our configuration class by the CLI
    # are usually full of duplicates and unconsistant keys, we make sure
    # to clean up that input, before doing any configuration work.
    #
    # @param attributes [Hash] list of key/values
    # @return [Hash] a clean list of key/values
    #
    def prepare_attributes(attributes)
      # Convert string keys to symbols
      symboled_attributes = Checklister::Sanitizer.symbolize attributes
      # Clean up user_attributes from unwanted, nil and duplicate options
      symboled_attributes.select { |key, _| ATTRIBUTES.include? key }
                         .delete_if { |_, v| v.nil? }
    end
  end
end
