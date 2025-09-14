# frozen_string_literal: true

module Rails
  module Snowflake
    class Railtie < ::Rails::Railtie
      initializer "snowflake_id.register_field_type" do
        ActiveSupport.on_load(:active_record) do
          ActiveRecord::ConnectionAdapters::TableDefinition.prepend(Rails::Snowflake::ColumnMethods)

          if defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
            ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:snowflake] = { name: "bigint" }
          else
            raise "Rails::Snowflake: Unsupported database adapter. Only PostgreSQL is supported."
          end
        end
      end

      rake_tasks do
        load "rails/snowflake/database_tasks.rb"
      end
    end
  end
end
