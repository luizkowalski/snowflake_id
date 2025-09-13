# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"


module RailsSnowflake
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      TEMPLATES = File.join(File.dirname(__FILE__), "templates")
      source_paths << TEMPLATES

      desc "Install RailsSnowflake by creating a migration to setup the timestamp_id function"

      def create_migration_file
        migration_template "install_rails_snowflake.rb.erb", File.join(db_migrate_path, "install_rails_snowflake.rb")
      end

      private

      def migration_version
        "[#{ActiveRecord::VERSION::STRING.to_f}]"
      end
    end
  end
end
