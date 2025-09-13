module RailsSnowflake
  class Railtie < ::Rails::Railtie
    initializer "rails_snowflake.register_field_type" do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::ConnectionAdapters::TableDefinition.prepend(RailsSnowflake::ConnectionAdapters::ColumnMethods)

        if defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
          ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:snowflake] = { name: "bigint" }
        else
          raise "RailsSnowflake: Unsupported database adapter. Only PostgreSQL is supported."
        end
      end
    end

    rake_tasks do
      load "rails_snowflake/database_tasks.rb"
    end
  end
end
