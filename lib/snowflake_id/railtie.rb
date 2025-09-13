module SnowflakeId
  class Railtie < ::Rails::Railtie
    initializer "snowflake_id.register_field_type" do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::ConnectionAdapters::TableDefinition.prepend(SnowflakeId::ColumnMethods)

        if defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
          ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:snowflake] = { name: "bigint" }
        else
          raise "SnowflakeId: Unsupported database adapter. Only PostgreSQL is supported."
        end
      end
    end

    rake_tasks do
      load "snowflake_id/database_tasks.rb"
    end
  end
end
