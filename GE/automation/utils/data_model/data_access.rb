module DataModel

  class DataAccess

    class << self
      #
      # Loads the data from configuration file
      #
      def load_data
        @config ||= YAML::load_file('config/data/gd_data.yml')
      end
    end

  end # End ProvisionModel class
end # End Module