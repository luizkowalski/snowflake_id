# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module Snowflake
  class InstallGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration

    TEMPLATES = File.join(File.dirname(__FILE__), "templates")
    source_paths << TEMPLATES

    desc "Install Rails::Snowflake by creating a migration to setup the timestamp_id function"

    def create_migration_file
      migration_template "install_snowflake_id.rb.erb", File.join(db_migrate_path, "install_snowflake_id.rb")
    end

    private

    def migration_version
      "[#{ActiveRecord::VERSION::STRING.to_f}]"
    end
  end
end
